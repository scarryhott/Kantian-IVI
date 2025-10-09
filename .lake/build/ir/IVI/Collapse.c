// Lean compiler output
// Module: IVI.Collapse
// Imports: Init IVI.Intangible IVI.Harmonics IVI.Invariant
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
LEAN_EXPORT uint8_t l_IVI_ICollapseCfg_grainSafeBool(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_grainCollapseBool___boxed(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_IVI_ICollapseCfg_grainCollapseBool(lean_object*, lean_object*);
double l_IVI_graininessScore(lean_object*);
double lean_float_add(double, double);
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_collapseScore___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_grainSafeBool___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter(lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_float_decLe(double, double);
LEAN_EXPORT double l_IVI_ICollapseCfg_collapseScore(lean_object*, lean_object*);
lean_object* l_IVI_Invariant_resonanceMatrixW(lean_object*, lean_object*);
LEAN_EXPORT double l_IVI_ICollapseCfg_collapseScore(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; double x_5; 
x_3 = lean_ctor_get(x_1, 0);
lean_inc_ref(x_3);
lean_dec_ref(x_1);
x_4 = l_IVI_Invariant_resonanceMatrixW(x_3, x_2);
x_5 = l_IVI_graininessScore(x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_collapseScore___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; lean_object* x_4; 
x_3 = l_IVI_ICollapseCfg_collapseScore(x_1, x_2);
x_4 = lean_box_float(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_IVI_ICollapseCfg_grainSafeBool(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; uint8_t x_5; 
x_3 = lean_ctor_get_float(x_1, sizeof(void*)*1);
x_4 = l_IVI_ICollapseCfg_collapseScore(x_1, x_2);
x_5 = lean_float_decLe(x_4, x_3);
return x_5;
}
}
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_grainSafeBool___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_IVI_ICollapseCfg_grainSafeBool(x_1, x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT uint8_t l_IVI_ICollapseCfg_grainCollapseBool(lean_object* x_1, lean_object* x_2) {
_start:
{
double x_3; double x_4; double x_5; double x_6; uint8_t x_7; 
x_3 = lean_ctor_get_float(x_1, sizeof(void*)*1);
x_4 = lean_ctor_get_float(x_1, sizeof(void*)*1 + 8);
x_5 = lean_float_add(x_3, x_4);
x_6 = l_IVI_ICollapseCfg_collapseScore(x_1, x_2);
x_7 = lean_float_decLe(x_5, x_6);
return x_7;
}
}
LEAN_EXPORT lean_object* l_IVI_ICollapseCfg_grainCollapseBool___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_IVI_ICollapseCfg_grainCollapseBool(x_1, x_2);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_dec(x_3);
lean_inc(x_2);
return x_2;
}
else
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; 
x_4 = lean_ctor_get(x_1, 0);
lean_inc(x_4);
x_5 = lean_ctor_get(x_1, 1);
lean_inc(x_5);
lean_dec_ref(x_1);
x_6 = lean_apply_2(x_3, x_4, x_5);
return x_6;
}
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg(x_2, x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___redArg(x_1, x_2, x_3);
lean_dec(x_2);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l___private_IVI_Collapse_0__IVI_harmonicSummary_match__1_splitter(x_1, x_2, x_3, x_4);
lean_dec(x_3);
return x_5;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_1) == 0)
{
lean_dec(x_3);
lean_inc(x_2);
return x_2;
}
else
{
lean_object* x_4; 
x_4 = lean_apply_2(x_3, x_1, lean_box(0));
return x_4;
}
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg(x_2, x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___redArg(x_1, x_2, x_3);
lean_dec(x_2);
return x_4;
}
}
LEAN_EXPORT lean_object* l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; 
x_5 = l___private_IVI_Collapse_0__IVI_spectralGraininess_match__1_splitter(x_1, x_2, x_3, x_4);
lean_dec(x_3);
return x_5;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Intangible(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Harmonics(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Invariant(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_Collapse(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Intangible(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Harmonics(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Invariant(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
