#include <string>
#include "codegenerator.h"


extern "C"
	{
	#include <caml/mlvalues.h>
	#include <caml/memory.h>
	#include <caml/custom.h>
	#include <caml/alloc.h>
	//#include <caml/callback.h>
	//#include <caml/fail.h>
	}


using namespace highlight;


typedef struct _obj_t
	{
	CodeGenerator* gen;
	} obj_t;


extern "C" void finalise_generator (value v_custom)
	{
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	CodeGenerator::deleteInstance (obj -> gen);
	}


static struct custom_operations custom_ops =
	{
	identifier:	(char *) "camlhighlight",
	finalize:	finalise_generator,
	compare:	custom_compare_default,
	hash:		custom_hash_default,
	serialize:	custom_serialize_default,
	deserialize:	custom_deserialize_default
	};


extern "C" CAMLprim value create (void)
	{
	CAMLparam0 ();
	CAMLlocal1 (v_custom);
	obj_t obj;
	obj.gen = CodeGenerator::getInstance (highlight::HTML);
	v_custom = caml_alloc_custom (&custom_ops, sizeof (obj_t), 0, 1);
	memcpy (Data_custom_val (v_custom), &obj, sizeof (obj_t));
	CAMLreturn (v_custom);
	}


extern "C" CAMLprim value init_theme (value v_custom, value v_theme)
	{
	CAMLparam2 (v_custom, v_theme);
	CAMLlocal1 (v_res);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	string theme = String_val (v_theme);
	bool res = obj -> gen -> initTheme (theme);
	v_res = Val_bool (res);
	CAMLreturn (v_res);
	}


extern "C" CAMLprim value load_language (value v_custom, value v_lang)
	{
	CAMLparam2 (v_custom, v_lang);
	CAMLlocal1 (v_res);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	string lang = String_val (v_lang);
	LoadResult res = obj -> gen -> loadLanguage (lang);
	v_res = Val_long (res);
	CAMLreturn (v_res);
	}


extern "C" CAMLprim value generate_string (value v_custom, value v_src)
	{
	CAMLparam2 (v_custom, v_src);
	CAMLlocal1 (v_res);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	string src = String_val (v_src);
	string res = obj -> gen -> generateString (src);
	v_res = caml_copy_string (res.c_str ());
	CAMLreturn (v_res);
	}


extern "C" CAMLprim void set_encoding (value v_custom, value v_encoding)
	{
	CAMLparam2 (v_custom, v_encoding);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	string encoding = String_val (v_encoding);
	obj -> gen -> setEncoding (encoding);
	CAMLreturn0;
	}


extern "C" CAMLprim void set_fragment_code (value v_custom, value v_fragment)
	{
	CAMLparam2 (v_custom, v_fragment);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	bool fragment = Bool_val (v_fragment);
	obj -> gen -> setFragmentCode (fragment);
	CAMLreturn0;
	}


extern "C" CAMLprim value get_style_name (value v_custom)
	{
	CAMLparam1 (v_custom);
	CAMLlocal1 (v_res);
	obj_t* obj = (obj_t*) Data_custom_val (v_custom);
	string res = obj -> gen -> getStyleName ();
	v_res = caml_copy_string (res.c_str ());
	CAMLreturn (v_res);
	}

