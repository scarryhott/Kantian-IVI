// Lean compiler output
// Module: IVI.WeylBounds
// Imports: Init IVI.Invariant IVI.RealSpec IVI.Will IVI.FloatSpec
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
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff___boxed(lean_object*, lean_object*);
static double l_IVI_WeylBounds_matrixNormInf___closed__0;
LEAN_EXPORT lean_object* l_IVI_WeylBounds_StepDeltaBounds_ctorIdx___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1;
LEAN_EXPORT double l_IVI_WeylBounds_matrixNormInf(lean_object*);
double l_Float_ofScientific(lean_object*, uint8_t, lean_object*);
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_WeylBounds_StepDeltaBounds_ctorIdx(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static uint8_t l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1___closed__0;
uint8_t lean_float_decLe(double, double);
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixNormInf___boxed(lean_object*);
static double _init_l_IVI_WeylBounds_matrixNormInf___closed__0() {
_start:
{
lean_object* x_1; uint8_t x_2; lean_object* x_3; double x_4; 
x_1 = lean_unsigned_to_nat(1u);
x_2 = 1;
x_3 = lean_unsigned_to_nat(0u);
x_4 = l_Float_ofScientific(x_3, x_2, x_1);
return x_4;
}
}
LEAN_EXPORT double l_IVI_WeylBounds_matrixNormInf(lean_object* x_1) {
_start:
{
double x_2; 
x_2 = l_IVI_WeylBounds_matrixNormInf___closed__0;
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixNormInf___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = l_IVI_WeylBounds_matrixNormInf(x_1);
lean_dec(x_1);
x_3 = lean_box_float(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_box(0);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_WeylBounds_matrixDiff(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
return x_3;
}
}
static uint8_t _init_l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1___closed__0() {
_start:
{
double x_1; uint8_t x_2; 
x_1 = l_IVI_WeylBounds_matrixNormInf___closed__0;
x_2 = lean_float_decLe(x_1, x_1);
return x_2;
}
}
static uint8_t _init_l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1() {
_start:
{
uint8_t x_1; 
x_1 = l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1___closed__0;
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_StepDeltaBounds_ctorIdx(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = lean_unsigned_to_nat(0u);
return x_6;
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_StepDeltaBounds_ctorIdx___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = l_IVI_WeylBounds_StepDeltaBounds_ctorIdx(x_1, x_2, x_3, x_4, x_5);
lean_dec_ref(x_5);
lean_dec(x_4);
lean_dec(x_3);
lean_dec_ref(x_2);
lean_dec_ref(x_1);
return x_6;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Invariant(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_RealSpec(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Will(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_FloatSpec(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_WeylBounds(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Invariant(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_RealSpec(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Will(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_FloatSpec(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_WeylBounds_matrixNormInf___closed__0 = _init_l_IVI_WeylBounds_matrixNormInf___closed__0();
l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1___closed__0 = _init_l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1___closed__0();
l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1 = _init_l_IVI_WeylBounds_matrixNormInf__nonneg___nativeDecide__1__1();
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
