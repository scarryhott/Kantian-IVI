// Lean compiler output
// Module: IVI.SafeFloat
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
double lean_float_mul(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_lt___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_add___boxed(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_IVI_SafeFloat_zero___nativeDecide__3;
uint8_t lean_float_decLt(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_abs___boxed(lean_object*);
LEAN_EXPORT uint8_t l_IVI_SafeFloat_zero___nativeDecide__1;
static uint8_t l_IVI_SafeFloat_one___nativeDecide__1___closed__1;
LEAN_EXPORT lean_object* l_IVI_SafeFloat_add(double, double);
LEAN_EXPORT uint8_t l_IVI_SafeFloat_one___nativeDecide__1;
double lean_float_add(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ofFloat_x3f(double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_le___boxed(lean_object*, lean_object*);
uint8_t lean_float_isnan(double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_instToString;
static double l_IVI_SafeFloat_zero___nativeDecide__1___closed__0;
LEAN_EXPORT double l_IVI_SafeFloat_one;
LEAN_EXPORT lean_object* l_IVI_SafeFloat_mul___boxed(lean_object*, lean_object*);
double l_Float_ofScientific(lean_object*, uint8_t, lean_object*);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_sub(double, double);
static uint8_t l_IVI_SafeFloat_zero___nativeDecide__1___closed__1;
LEAN_EXPORT lean_object* l_IVI_SafeFloat_abs(double);
static uint8_t l_IVI_SafeFloat_zero___nativeDecide__3___closed__0;
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ofFloat_x3f___boxed(lean_object*);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_mul(double, double);
lean_object* lean_float_to_string(double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_instToString___lam__0(double);
static double l_IVI_SafeFloat_one___nativeDecide__1___closed__0;
uint8_t l_instDecidableNot___redArg(uint8_t);
uint8_t lean_float_decLe(double, double);
LEAN_EXPORT uint8_t l_IVI_SafeFloat_le(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_instToString___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ctorIdx___boxed(lean_object*);
static uint8_t l_IVI_SafeFloat_one___nativeDecide__3___closed__0;
double fabs(double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_sub___boxed(lean_object*, lean_object*);
LEAN_EXPORT double l_IVI_SafeFloat_zero;
LEAN_EXPORT uint8_t l_IVI_SafeFloat_lt(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ctorIdx(double);
uint8_t lean_float_isfinite(double);
LEAN_EXPORT uint8_t l_IVI_SafeFloat_one___nativeDecide__3;
double lean_float_sub(double, double);
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ctorIdx(double x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_unsigned_to_nat(0u);
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ctorIdx___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_SafeFloat_ctorIdx(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ofFloat_x3f(double x_1) {
_start:
{
uint8_t x_2; 
x_2 = lean_float_isfinite(x_1);
if (x_2 == 0)
{
lean_object* x_3; 
x_3 = lean_box(0);
return x_3;
}
else
{
uint8_t x_4; uint8_t x_5; 
x_4 = lean_float_isnan(x_1);
x_5 = l_instDecidableNot___redArg(x_4);
if (x_5 == 0)
{
lean_object* x_6; 
x_6 = lean_box(0);
return x_6;
}
else
{
lean_object* x_7; lean_object* x_8; 
x_7 = lean_box_float(x_1);
x_8 = lean_alloc_ctor(1, 1, 0);
lean_ctor_set(x_8, 0, x_7);
return x_8;
}
}
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_ofFloat_x3f___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_SafeFloat_ofFloat_x3f(x_2);
return x_3;
}
}
static double _init_l_IVI_SafeFloat_zero___nativeDecide__1___closed__0() {
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
static uint8_t _init_l_IVI_SafeFloat_zero___nativeDecide__1___closed__1() {
_start:
{
double x_1; uint8_t x_2; 
x_1 = l_IVI_SafeFloat_zero___nativeDecide__1___closed__0;
x_2 = lean_float_isfinite(x_1);
return x_2;
}
}
static uint8_t _init_l_IVI_SafeFloat_zero___nativeDecide__1() {
_start:
{
uint8_t x_1; 
x_1 = l_IVI_SafeFloat_zero___nativeDecide__1___closed__1;
return x_1;
}
}
static uint8_t _init_l_IVI_SafeFloat_zero___nativeDecide__3___closed__0() {
_start:
{
double x_1; uint8_t x_2; 
x_1 = l_IVI_SafeFloat_zero___nativeDecide__1___closed__0;
x_2 = lean_float_isnan(x_1);
return x_2;
}
}
static uint8_t _init_l_IVI_SafeFloat_zero___nativeDecide__3() {
_start:
{
uint8_t x_1; uint8_t x_2; 
x_1 = 1;
x_2 = l_IVI_SafeFloat_zero___nativeDecide__3___closed__0;
if (x_2 == 0)
{
return x_1;
}
else
{
uint8_t x_3; 
x_3 = 0;
return x_3;
}
}
}
static double _init_l_IVI_SafeFloat_zero() {
_start:
{
double x_1; 
x_1 = l_IVI_SafeFloat_zero___nativeDecide__1___closed__0;
return x_1;
}
}
static double _init_l_IVI_SafeFloat_one___nativeDecide__1___closed__0() {
_start:
{
lean_object* x_1; uint8_t x_2; lean_object* x_3; double x_4; 
x_1 = lean_unsigned_to_nat(1u);
x_2 = 1;
x_3 = lean_unsigned_to_nat(10u);
x_4 = l_Float_ofScientific(x_3, x_2, x_1);
return x_4;
}
}
static uint8_t _init_l_IVI_SafeFloat_one___nativeDecide__1___closed__1() {
_start:
{
double x_1; uint8_t x_2; 
x_1 = l_IVI_SafeFloat_one___nativeDecide__1___closed__0;
x_2 = lean_float_isfinite(x_1);
return x_2;
}
}
static uint8_t _init_l_IVI_SafeFloat_one___nativeDecide__1() {
_start:
{
uint8_t x_1; 
x_1 = l_IVI_SafeFloat_one___nativeDecide__1___closed__1;
return x_1;
}
}
static uint8_t _init_l_IVI_SafeFloat_one___nativeDecide__3___closed__0() {
_start:
{
double x_1; uint8_t x_2; 
x_1 = l_IVI_SafeFloat_one___nativeDecide__1___closed__0;
x_2 = lean_float_isnan(x_1);
return x_2;
}
}
static uint8_t _init_l_IVI_SafeFloat_one___nativeDecide__3() {
_start:
{
uint8_t x_1; uint8_t x_2; 
x_1 = 1;
x_2 = l_IVI_SafeFloat_one___nativeDecide__3___closed__0;
if (x_2 == 0)
{
return x_1;
}
else
{
uint8_t x_3; 
x_3 = 0;
return x_3;
}
}
}
static double _init_l_IVI_SafeFloat_one() {
_start:
{
double x_1; 
x_1 = l_IVI_SafeFloat_one___nativeDecide__1___closed__0;
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_add(double x_1, double x_2) {
_start:
{
double x_3; lean_object* x_4; 
x_3 = lean_float_add(x_1, x_2);
x_4 = l_IVI_SafeFloat_ofFloat_x3f(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_add___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; lean_object* x_5; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = lean_unbox_float(x_2);
lean_dec_ref(x_2);
x_5 = l_IVI_SafeFloat_add(x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_sub(double x_1, double x_2) {
_start:
{
double x_3; lean_object* x_4; 
x_3 = lean_float_sub(x_1, x_2);
x_4 = l_IVI_SafeFloat_ofFloat_x3f(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_sub___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; lean_object* x_5; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = lean_unbox_float(x_2);
lean_dec_ref(x_2);
x_5 = l_IVI_SafeFloat_sub(x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_mul(double x_1, double x_2) {
_start:
{
double x_3; lean_object* x_4; 
x_3 = lean_float_mul(x_1, x_2);
x_4 = l_IVI_SafeFloat_ofFloat_x3f(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_mul___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; lean_object* x_5; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = lean_unbox_float(x_2);
lean_dec_ref(x_2);
x_5 = l_IVI_SafeFloat_mul(x_3, x_4);
return x_5;
}
}
LEAN_EXPORT uint8_t l_IVI_SafeFloat_le(double x_1, double x_2) {
_start:
{
uint8_t x_3; 
x_3 = lean_float_decLe(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_le___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = lean_unbox_float(x_2);
lean_dec_ref(x_2);
x_5 = l_IVI_SafeFloat_le(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT uint8_t l_IVI_SafeFloat_lt(double x_1, double x_2) {
_start:
{
uint8_t x_3; 
x_3 = lean_float_decLt(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_lt___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; uint8_t x_5; lean_object* x_6; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = lean_unbox_float(x_2);
lean_dec_ref(x_2);
x_5 = l_IVI_SafeFloat_lt(x_3, x_4);
x_6 = lean_box(x_5);
return x_6;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_abs(double x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = fabs(x_1);
x_3 = l_IVI_SafeFloat_ofFloat_x3f(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_abs___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_SafeFloat_abs(x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_instToString___lam__0(double x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_float_to_string(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_SafeFloat_instToString() {
_start:
{
lean_object* x_1; 
x_1 = lean_alloc_closure((void*)(l_IVI_SafeFloat_instToString___lam__0___boxed), 1, 0);
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_SafeFloat_instToString___lam__0___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_3 = l_IVI_SafeFloat_instToString___lam__0(x_2);
return x_3;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_SafeFloat(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_SafeFloat_zero___nativeDecide__1___closed__0 = _init_l_IVI_SafeFloat_zero___nativeDecide__1___closed__0();
l_IVI_SafeFloat_zero___nativeDecide__1___closed__1 = _init_l_IVI_SafeFloat_zero___nativeDecide__1___closed__1();
l_IVI_SafeFloat_zero___nativeDecide__1 = _init_l_IVI_SafeFloat_zero___nativeDecide__1();
l_IVI_SafeFloat_zero___nativeDecide__3___closed__0 = _init_l_IVI_SafeFloat_zero___nativeDecide__3___closed__0();
l_IVI_SafeFloat_zero___nativeDecide__3 = _init_l_IVI_SafeFloat_zero___nativeDecide__3();
l_IVI_SafeFloat_zero = _init_l_IVI_SafeFloat_zero();
l_IVI_SafeFloat_one___nativeDecide__1___closed__0 = _init_l_IVI_SafeFloat_one___nativeDecide__1___closed__0();
l_IVI_SafeFloat_one___nativeDecide__1___closed__1 = _init_l_IVI_SafeFloat_one___nativeDecide__1___closed__1();
l_IVI_SafeFloat_one___nativeDecide__1 = _init_l_IVI_SafeFloat_one___nativeDecide__1();
l_IVI_SafeFloat_one___nativeDecide__3___closed__0 = _init_l_IVI_SafeFloat_one___nativeDecide__3___closed__0();
l_IVI_SafeFloat_one___nativeDecide__3 = _init_l_IVI_SafeFloat_one___nativeDecide__3();
l_IVI_SafeFloat_one = _init_l_IVI_SafeFloat_one();
l_IVI_SafeFloat_instToString = _init_l_IVI_SafeFloat_instToString();
lean_mark_persistent(l_IVI_SafeFloat_instToString);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
