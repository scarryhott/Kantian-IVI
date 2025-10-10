// Lean compiler output
// Module: IVI.WeylBounds
// Imports: Init IVI.Invariant IVI.KakeyaBounds
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
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__0(lean_object*, lean_object*);
uint8_t lean_float_decLt(double, double);
double lean_float_add(double, double);
LEAN_EXPORT lean_object* l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT double l_IVI_WeylBounds_matrixNormInf(lean_object*);
double l_Float_ofScientific(lean_object*, uint8_t, lean_object*);
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff(lean_object*, lean_object*);
lean_object* l_List_reverse___redArg(lean_object*);
LEAN_EXPORT double l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0(double, lean_object*);
LEAN_EXPORT lean_object* l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___boxed(lean_object*, lean_object*);
static double l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0;
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__1(lean_object*, lean_object*);
lean_object* l_List_zipWith___at___List_zip_spec__0___redArg(lean_object*, lean_object*);
double fabs(double);
LEAN_EXPORT double l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1(double, lean_object*);
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixNormInf___boxed(lean_object*);
double lean_float_sub(double, double);
LEAN_EXPORT double l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0(double x_1, lean_object* x_2) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
return x_1;
}
else
{
lean_object* x_3; lean_object* x_4; double x_5; double x_6; double x_7; 
x_3 = lean_ctor_get(x_2, 0);
x_4 = lean_ctor_get(x_2, 1);
x_5 = lean_unbox_float(x_3);
x_6 = fabs(x_5);
x_7 = lean_float_add(x_1, x_6);
x_1 = x_7;
x_2 = x_4;
goto _start;
}
}
}
static double _init_l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0() {
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
LEAN_EXPORT double l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1(double x_1, lean_object* x_2) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
return x_1;
}
else
{
lean_object* x_3; lean_object* x_4; double x_5; double x_6; uint8_t x_7; 
x_3 = lean_ctor_get(x_2, 0);
x_4 = lean_ctor_get(x_2, 1);
x_5 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0;
x_6 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0(x_5, x_3);
x_7 = lean_float_decLt(x_1, x_6);
if (x_7 == 0)
{
x_2 = x_4;
goto _start;
}
else
{
x_1 = x_6;
x_2 = x_4;
goto _start;
}
}
}
}
LEAN_EXPORT double l_IVI_WeylBounds_matrixNormInf(lean_object* x_1) {
_start:
{
double x_2; double x_3; 
x_2 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0;
x_3 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1(x_2, x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; lean_object* x_5; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__0(x_3, x_2);
lean_dec(x_2);
x_5 = lean_box_float(x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; lean_object* x_5; 
x_3 = lean_unbox_float(x_1);
lean_dec_ref(x_1);
x_4 = l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1(x_3, x_2);
lean_dec(x_2);
x_5 = lean_box_float(x_4);
return x_5;
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
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__0(lean_object* x_1, lean_object* x_2) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_object* x_3; 
x_3 = l_List_reverse___redArg(x_2);
return x_3;
}
else
{
uint8_t x_4; 
x_4 = !lean_is_exclusive(x_1);
if (x_4 == 0)
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; double x_9; double x_10; double x_11; lean_object* x_12; 
x_5 = lean_ctor_get(x_1, 0);
x_6 = lean_ctor_get(x_1, 1);
x_7 = lean_ctor_get(x_5, 0);
lean_inc(x_7);
x_8 = lean_ctor_get(x_5, 1);
lean_inc(x_8);
lean_dec(x_5);
x_9 = lean_unbox_float(x_7);
lean_dec(x_7);
x_10 = lean_unbox_float(x_8);
lean_dec(x_8);
x_11 = lean_float_sub(x_9, x_10);
x_12 = lean_box_float(x_11);
lean_ctor_set(x_1, 1, x_2);
lean_ctor_set(x_1, 0, x_12);
{
lean_object* _tmp_0 = x_6;
lean_object* _tmp_1 = x_1;
x_1 = _tmp_0;
x_2 = _tmp_1;
}
goto _start;
}
else
{
lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; double x_18; double x_19; double x_20; lean_object* x_21; lean_object* x_22; 
x_14 = lean_ctor_get(x_1, 0);
x_15 = lean_ctor_get(x_1, 1);
lean_inc(x_15);
lean_inc(x_14);
lean_dec(x_1);
x_16 = lean_ctor_get(x_14, 0);
lean_inc(x_16);
x_17 = lean_ctor_get(x_14, 1);
lean_inc(x_17);
lean_dec(x_14);
x_18 = lean_unbox_float(x_16);
lean_dec(x_16);
x_19 = lean_unbox_float(x_17);
lean_dec(x_17);
x_20 = lean_float_sub(x_18, x_19);
x_21 = lean_box_float(x_20);
x_22 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_22, 0, x_21);
lean_ctor_set(x_22, 1, x_2);
x_1 = x_15;
x_2 = x_22;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__1(lean_object* x_1, lean_object* x_2) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_object* x_3; 
x_3 = l_List_reverse___redArg(x_2);
return x_3;
}
else
{
uint8_t x_4; 
x_4 = !lean_is_exclusive(x_1);
if (x_4 == 0)
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; 
x_5 = lean_ctor_get(x_1, 0);
x_6 = lean_ctor_get(x_1, 1);
x_7 = lean_ctor_get(x_5, 0);
lean_inc(x_7);
x_8 = lean_ctor_get(x_5, 1);
lean_inc(x_8);
lean_dec(x_5);
x_9 = l_List_zipWith___at___List_zip_spec__0___redArg(x_7, x_8);
x_10 = lean_box(0);
x_11 = l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__0(x_9, x_10);
lean_ctor_set(x_1, 1, x_2);
lean_ctor_set(x_1, 0, x_11);
{
lean_object* _tmp_0 = x_6;
lean_object* _tmp_1 = x_1;
x_1 = _tmp_0;
x_2 = _tmp_1;
}
goto _start;
}
else
{
lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; lean_object* x_18; lean_object* x_19; lean_object* x_20; 
x_13 = lean_ctor_get(x_1, 0);
x_14 = lean_ctor_get(x_1, 1);
lean_inc(x_14);
lean_inc(x_13);
lean_dec(x_1);
x_15 = lean_ctor_get(x_13, 0);
lean_inc(x_15);
x_16 = lean_ctor_get(x_13, 1);
lean_inc(x_16);
lean_dec(x_13);
x_17 = l_List_zipWith___at___List_zip_spec__0___redArg(x_15, x_16);
x_18 = lean_box(0);
x_19 = l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__0(x_17, x_18);
x_20 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_20, 0, x_19);
lean_ctor_set(x_20, 1, x_2);
x_1 = x_14;
x_2 = x_20;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* l_IVI_WeylBounds_matrixDiff(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; 
x_3 = l_List_zipWith___at___List_zip_spec__0___redArg(x_1, x_2);
x_4 = lean_box(0);
x_5 = l_List_mapTR_loop___at___IVI_WeylBounds_matrixDiff_spec__1(x_3, x_4);
return x_5;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Invariant(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_KakeyaBounds(uint8_t builtin, lean_object*);
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
res = initialize_IVI_KakeyaBounds(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0 = _init_l_List_foldl___at___IVI_WeylBounds_matrixNormInf_spec__1___closed__0();
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
