/********************************************************************************/
/*	Source-highlight_stubs.cpp
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*/
/********************************************************************************/

#include <string>
#include <sstream>
#include "srchilite/sourcehighlight.h"
#include "srchilite/langmap.h"


extern "C"
	{
	#include <caml/mlvalues.h>
	#include <caml/memory.h>
	#include <caml/alloc.h>
	#include <caml/callback.h>
	#include <caml/fail.h>
	}


using namespace std;
using namespace srchilite;


static SourceHighlight hiliter ("camlhighlight.outlang");
static LangMap mapper ("lang.map");


extern "C" CAMLprim value init (value v_unit)
	{
	CAMLparam1 (v_unit);
	mapper.open ();
	CAMLreturn (Val_unit);
	}


extern "C" CAMLprim value get_langs (value v_unit)
	{
	CAMLparam1 (v_unit);
	CAMLlocal2 (cons, rest);

	set <string> langs = mapper.getLangNames ();
	rest = Val_emptylist;

	for (set <string> :: const_reverse_iterator iter = langs.rbegin (); iter != langs.rend (); ++iter)
		{
		cons = caml_alloc (2, 0);
		Store_field (cons, 0, caml_copy_string (iter -> c_str ()));
		Store_field (cons, 1, rest);
		rest = cons;
		}

	CAMLreturn (rest);
	}


extern "C" CAMLprim value has_mapping (value v_lang)
	{
	CAMLparam1 (v_lang);
	CAMLlocal1 (v_res);

	string lang (String_val (v_lang));
	string langdef = mapper.getMappedFileName (lang);
	bool res = (langdef != "");
	v_res = Val_bool (res);

	CAMLreturn (v_res);
	}


extern "C" CAMLprim value highlight (value v_lang, value v_src)
	{
	CAMLparam2 (v_lang, v_src);
	CAMLlocal1 (v_res);

	string src (String_val (v_src));
	string lang (String_val (v_lang));
	string langdef = mapper.getMappedFileName (lang);

	if (langdef == "")
		{
		caml_raise_with_string (*caml_named_value ("invalid_lang"), lang.c_str ());
		}

	istringstream in (src);
	ostringstream out;

	hiliter.highlight (in, out, langdef);
	string res = out.str ();
	v_res = caml_copy_string (res.c_str ());

	CAMLreturn (v_res);
	}

