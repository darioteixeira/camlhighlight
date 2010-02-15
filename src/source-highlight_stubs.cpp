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
	#include <caml/custom.h>
	#include <caml/alloc.h>
	}


using namespace std;
using namespace srchilite;


static SourceHighlight hiliter ("camlhighlight.outlang");
static LangMap mapper ("lang.map");


extern "C" CAMLprim value get_mapping (value v_lang)
	{
	CAMLparam1 (v_lang);
	CAMLlocal1 (v_langdef);

	string lang (String_val (v_lang));
	string langdef = mapper.getMappedFileName (lang);

	v_langdef = caml_copy_string (langdef.c_str ());

	CAMLreturn (v_langdef);
	}


extern "C" CAMLprim value highlight (value v_src, value v_langdef)
	{
	CAMLparam2 (v_src, v_langdef);
	CAMLlocal1 (v_res);

	string src (String_val (v_src));
	string langdef (String_val (v_langdef));

	istringstream in (src);
	ostringstream out;

	hiliter.highlight (in, out, langdef);
	string res = out.str ();
	v_res = caml_copy_string (res.c_str ());

	CAMLreturn (v_res);
	}

