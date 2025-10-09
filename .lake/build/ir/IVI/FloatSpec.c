// Lean compiler output
// Module: IVI.FloatSpec
// Imports: Init
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
LEAN_EXPORT lean_object* l_IVI_ulpBudget___boxed(lean_object*);
double lean_float_mul(double, double);
LEAN_EXPORT double l_IVI_ulpBudget(double);
LEAN_EXPORT double l_IVI_toReal(double);
double l_Float_ofScientific(lean_object*, uint8_t, lean_object*);
LEAN_EXPORT lean_object* l_IVI_toReal___boxed(lean_object*);
double fabs(double);
static double l_IVI_ulpBudget___closed__0;
static double _init_l_IVI_ulpBudget___closed__0() {
_start:
{
lean_object* x_1; uint8_t x_2; lean_object* x_3; double x_4; 
x_1 = lean_unsigned_to_nat(7u);
x_2 = 1;
x_3 = lean_unsigned_to_nat(1u);
x_4 = l_Float_ofScientific(x_3, x_2, x_1);
return x_4;
}
}
LEAN_EXPORT double l_IVI_ulpBudget(double x_1) {
_start:
{
double x_2; double x_3; double x_4; 
x_2 = fabs(x_1);
x_3 = l_IVI_ulpBudget___closed__0;
x_4 = lean_float_mul(x_2, x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_ulpBudget___boxed(lean_object* x_1) {
_start:
{
double x_2; double x_3; lean_object* x_4; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_ulpBudget(x_2);
x_4 = lean_box_float(x_3);
return x_4;
}
}
LEAN_EXPORT double l_IVI_toReal(double x_1) {
_start:
{
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_toReal___boxed(lean_object* x_1) {
_start:
{
double x_2; double x_3; lean_object* x_4; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_toReal(x_2);
x_4 = lean_box_float(x_3);
return x_4;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_FloatSpec(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_ulpBudget___closed__0 = _init_l_IVI_ulpBudget___closed__0();
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
