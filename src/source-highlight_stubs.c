/********************************************************************************/
/*  Source-highlight_stubs.c
    Copyright (c) 2010-2016 Dario Teixeira <dario.teixeira@nleyten.com>
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


/********************************************************************************/
/* Module variables and constants.                                              */
/********************************************************************************/

static string outlang ("sexp.outlang");     // Default outlang definition file.
static string langmap ("lang.map");         // Default language map file.
static SourceHighlight *hiliter = 0;        // The global hiliter.
static LangMap *mapper = 0;                 // The global mapper.


/********************************************************************************/
/* API functions.                                                               */
/********************************************************************************/

extern "C" CAMLprim value init_hiliter (value v_unit)
    {
    CAMLparam1 (v_unit);

    if (hiliter) {delete hiliter;}

    try {
        hiliter = new SourceHighlight (outlang);
        hiliter -> checkOutLangDef (outlang);
        hiliter -> setTabSpaces (8);
        }
    catch (...)
        {
        caml_raise_constant (*caml_named_value ("Cannot_initialize_hiliter"));
        }
    
    CAMLreturn (Val_unit);
    }


extern "C" CAMLprim value init_mapper (value v_unit)
    {
    CAMLparam1 (v_unit);

    if (mapper) {delete mapper;}

    try {
        mapper = new LangMap (langmap);
        mapper -> open ();
        }
    catch (...)
        {
        caml_raise_constant (*caml_named_value ("Cannot_initialize_mapper"));
        }

    CAMLreturn (Val_unit);
    }


extern "C" CAMLprim value set_tabspaces (value v_num)
    {
    CAMLparam1 (v_num);

    if (hiliter)
        {
        int num = Int_val (v_num);
        hiliter -> setTabSpaces (num);

        CAMLreturn (Val_unit);
        }
    else
        {
        caml_raise_constant (*caml_named_value ("Uninitialized"));
        }
    }


extern "C" CAMLprim value get_langs (value v_unit)
    {
    CAMLparam1 (v_unit);
    CAMLlocal2 (cons, rest);

    if (mapper)
        {
        set <string> langs = mapper -> getLangNames ();
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
    else
        {
        caml_raise_constant (*caml_named_value ("Uninitialized"));
        }
    }


extern "C" CAMLprim value has_mapping (value v_lang)
    {
    CAMLparam1 (v_lang);
    CAMLlocal1 (v_res);

    if (mapper)
        {
        string lang (String_val (v_lang));
        string langdef = mapper -> getMappedFileName (lang);
        bool res = (langdef != "");
        v_res = Val_bool (res);
        CAMLreturn (v_res);
        }
    else
        {
        caml_raise_constant (*caml_named_value ("Uninitialized"));
        }
    }


extern "C" CAMLprim value highlight (value v_lang, value v_src)
    {
    CAMLparam2 (v_lang, v_src);
    CAMLlocal1 (v_res);

    if (mapper && hiliter)
        {
        string src (String_val (v_src));
        string lang (String_val (v_lang));
        string langdef = mapper -> getMappedFileName (lang);

        if (langdef == "")
            {
            caml_raise_with_string (*caml_named_value ("Unknown_language"), lang.c_str ());
            }

        istringstream in (src);
        ostringstream out;

        try {
            hiliter -> highlight (in, out, langdef);
            }
        catch (...)
            {
            caml_raise_with_string (*caml_named_value ("Hiliter_error"), langdef.c_str ());
            }

        string res = out.str ();
        v_res = caml_copy_string (res.c_str ());
        CAMLreturn (v_res);
        }
    else
        {
        caml_raise_constant (*caml_named_value ("Uninitialized"));
        }
    }

