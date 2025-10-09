// Lean compiler output
// Module: IVI.Will
// Imports: Init IVI.SVObj IVI.Bounds IVI.SchemaLaw
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
static lean_object* l_IVI_Will_idle___lam__0___closed__0;
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__2___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT double l_IVI_Will_idle___lam__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__2(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_Will_idle;
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__0(lean_object*, lean_object*);
static lean_object* _init_l_IVI_Will_idle___lam__0___closed__0() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("idle", 4, 4);
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__0(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_Will_idle___lam__0___closed__0;
return x_3;
}
}
LEAN_EXPORT double l_IVI_Will_idle___lam__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; double x_4; 
x_3 = lean_ctor_get(x_2, 1);
x_4 = lean_ctor_get_float(x_3, sizeof(void*)*2);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__2(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_inc_ref(x_2);
return x_2;
}
}
static lean_object* _init_l_IVI_Will_idle() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; lean_object* x_4; 
x_1 = lean_alloc_closure((void*)(l_IVI_Will_idle___lam__0___boxed), 2, 0);
x_2 = lean_alloc_closure((void*)(l_IVI_Will_idle___lam__1___boxed), 2, 0);
x_3 = lean_alloc_closure((void*)(l_IVI_Will_idle___lam__2___boxed), 2, 0);
x_4 = lean_alloc_ctor(0, 3, 0);
lean_ctor_set(x_4, 0, x_1);
lean_ctor_set(x_4, 1, x_2);
lean_ctor_set(x_4, 2, x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__0___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_Will_idle___lam__0(x_1, x_2);
lean_dec_ref(x_2);
lean_dec_ref(x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__1___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; lean_object* x_4; 
x_3 = l_IVI_Will_idle___lam__1(x_1, x_2);
lean_dec_ref(x_2);
lean_dec_ref(x_1);
x_4 = lean_box_float(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_Will_idle___lam__2___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_Will_idle___lam__2(x_1, x_2);
lean_dec_ref(x_2);
lean_dec_ref(x_1);
return x_3;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SVObj(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Bounds(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SchemaLaw(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_Will(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SVObj(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Bounds(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SchemaLaw(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_Will_idle___lam__0___closed__0 = _init_l_IVI_Will_idle___lam__0___closed__0();
lean_mark_persistent(l_IVI_Will_idle___lam__0___closed__0);
l_IVI_Will_idle = _init_l_IVI_Will_idle();
lean_mark_persistent(l_IVI_Will_idle);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
