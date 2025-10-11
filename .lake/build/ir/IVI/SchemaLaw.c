// Lean compiler output
// Module: IVI.SchemaLaw
// Imports: Init IVI.Kakeya.Core IVI.SVObj
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
lean_object* l_Float_repr(double, lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__14;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__9;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__12;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__22;
double l_IVI_dirNorm(lean_object*);
lean_object* l_String_quote(lean_object*);
static lean_object* l_IVI_instReprSchemaContext___closed__0;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__13;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__11;
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_ctorIdx___boxed(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__15;
lean_object* lean_string_length(lean_object*);
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr___redArg(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__5;
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__8;
lean_object* lean_nat_to_int(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__16;
LEAN_EXPORT lean_object* l_IVI_SchemaContext_ctorIdx___boxed(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__6;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__4;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__1;
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_default___lam__0___boxed(lean_object*);
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_ctorIdx(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__18;
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr(lean_object*, lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__21;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__17;
lean_object* l_IVI_instReprDir3_repr___redArg(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__20;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__3;
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_default;
LEAN_EXPORT lean_object* l_IVI_SchemaContext_ctorIdx(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__7;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__19;
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr___boxed(lean_object*, lean_object*);
LEAN_EXPORT double l_IVI_SchemaLaw_default___lam__0(lean_object*);
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__10;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__0;
static lean_object* l_IVI_instReprSchemaContext_repr___redArg___closed__2;
LEAN_EXPORT lean_object* l_IVI_SchemaContext_ctorIdx(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_unsigned_to_nat(0u);
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_SchemaContext_ctorIdx___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_IVI_SchemaContext_ctorIdx(x_1);
lean_dec_ref(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__0() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("{ ", 2, 2);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__1() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("schema", 6, 6);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__2() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__1;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__3() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__2;
x_2 = lean_box(0);
x_3 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_3, 0, x_2);
lean_ctor_set(x_3, 1, x_1);
return x_3;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__4() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked(" := ", 4, 4);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__5() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__4;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__6() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__5;
x_2 = l_IVI_instReprSchemaContext_repr___redArg___closed__3;
x_3 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_3, 0, x_2);
lean_ctor_set(x_3, 1, x_1);
return x_3;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__7() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_unsigned_to_nat(10u);
x_2 = lean_nat_to_int(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__8() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked(",", 1, 1);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__9() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__8;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__10() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("concept", 7, 7);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__11() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__10;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__12() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_unsigned_to_nat(11u);
x_2 = lean_nat_to_int(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__13() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("direction", 9, 9);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__14() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__13;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__15() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_unsigned_to_nat(13u);
x_2 = lean_nat_to_int(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__16() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("intensity", 9, 9);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__17() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__16;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__18() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked(" }", 2, 2);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__19() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__0;
x_2 = lean_string_length(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__20() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__19;
x_2 = lean_nat_to_int(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__21() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__0;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext_repr___redArg___closed__22() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_instReprSchemaContext_repr___redArg___closed__18;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr___redArg(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; lean_object* x_4; double x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; uint8_t x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; lean_object* x_18; lean_object* x_19; lean_object* x_20; lean_object* x_21; lean_object* x_22; lean_object* x_23; lean_object* x_24; lean_object* x_25; lean_object* x_26; lean_object* x_27; lean_object* x_28; lean_object* x_29; lean_object* x_30; lean_object* x_31; lean_object* x_32; lean_object* x_33; lean_object* x_34; lean_object* x_35; lean_object* x_36; lean_object* x_37; lean_object* x_38; lean_object* x_39; lean_object* x_40; lean_object* x_41; lean_object* x_42; lean_object* x_43; lean_object* x_44; lean_object* x_45; lean_object* x_46; lean_object* x_47; lean_object* x_48; lean_object* x_49; lean_object* x_50; lean_object* x_51; lean_object* x_52; lean_object* x_53; lean_object* x_54; 
x_2 = lean_ctor_get(x_1, 0);
lean_inc_ref(x_2);
x_3 = lean_ctor_get(x_1, 1);
lean_inc_ref(x_3);
x_4 = lean_ctor_get(x_1, 2);
lean_inc_ref(x_4);
x_5 = lean_ctor_get_float(x_1, sizeof(void*)*3);
lean_dec_ref(x_1);
x_6 = l_IVI_instReprSchemaContext_repr___redArg___closed__5;
x_7 = l_IVI_instReprSchemaContext_repr___redArg___closed__6;
x_8 = l_IVI_instReprSchemaContext_repr___redArg___closed__7;
x_9 = l_String_quote(x_2);
x_10 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_10, 0, x_9);
x_11 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_11, 0, x_8);
lean_ctor_set(x_11, 1, x_10);
x_12 = 0;
x_13 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_13, 0, x_11);
lean_ctor_set_uint8(x_13, sizeof(void*)*1, x_12);
x_14 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_14, 0, x_7);
lean_ctor_set(x_14, 1, x_13);
x_15 = l_IVI_instReprSchemaContext_repr___redArg___closed__9;
x_16 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_16, 0, x_14);
lean_ctor_set(x_16, 1, x_15);
x_17 = lean_box(1);
x_18 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_18, 0, x_16);
lean_ctor_set(x_18, 1, x_17);
x_19 = l_IVI_instReprSchemaContext_repr___redArg___closed__11;
x_20 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_20, 0, x_18);
lean_ctor_set(x_20, 1, x_19);
x_21 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_21, 0, x_20);
lean_ctor_set(x_21, 1, x_6);
x_22 = l_IVI_instReprSchemaContext_repr___redArg___closed__12;
x_23 = l_String_quote(x_3);
x_24 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_24, 0, x_23);
x_25 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_25, 0, x_22);
lean_ctor_set(x_25, 1, x_24);
x_26 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_26, 0, x_25);
lean_ctor_set_uint8(x_26, sizeof(void*)*1, x_12);
x_27 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_27, 0, x_21);
lean_ctor_set(x_27, 1, x_26);
x_28 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_28, 0, x_27);
lean_ctor_set(x_28, 1, x_15);
x_29 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_29, 0, x_28);
lean_ctor_set(x_29, 1, x_17);
x_30 = l_IVI_instReprSchemaContext_repr___redArg___closed__14;
x_31 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_31, 0, x_29);
lean_ctor_set(x_31, 1, x_30);
x_32 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_32, 0, x_31);
lean_ctor_set(x_32, 1, x_6);
x_33 = l_IVI_instReprSchemaContext_repr___redArg___closed__15;
x_34 = lean_unsigned_to_nat(0u);
x_35 = l_IVI_instReprDir3_repr___redArg(x_4);
lean_dec_ref(x_4);
x_36 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_36, 0, x_33);
lean_ctor_set(x_36, 1, x_35);
x_37 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_37, 0, x_36);
lean_ctor_set_uint8(x_37, sizeof(void*)*1, x_12);
x_38 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_38, 0, x_32);
lean_ctor_set(x_38, 1, x_37);
x_39 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_39, 0, x_38);
lean_ctor_set(x_39, 1, x_15);
x_40 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_40, 0, x_39);
lean_ctor_set(x_40, 1, x_17);
x_41 = l_IVI_instReprSchemaContext_repr___redArg___closed__17;
x_42 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_42, 0, x_40);
lean_ctor_set(x_42, 1, x_41);
x_43 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_43, 0, x_42);
lean_ctor_set(x_43, 1, x_6);
x_44 = l_Float_repr(x_5, x_34);
x_45 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_45, 0, x_33);
lean_ctor_set(x_45, 1, x_44);
x_46 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_46, 0, x_45);
lean_ctor_set_uint8(x_46, sizeof(void*)*1, x_12);
x_47 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_47, 0, x_43);
lean_ctor_set(x_47, 1, x_46);
x_48 = l_IVI_instReprSchemaContext_repr___redArg___closed__20;
x_49 = l_IVI_instReprSchemaContext_repr___redArg___closed__21;
x_50 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_50, 0, x_49);
lean_ctor_set(x_50, 1, x_47);
x_51 = l_IVI_instReprSchemaContext_repr___redArg___closed__22;
x_52 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_52, 0, x_50);
lean_ctor_set(x_52, 1, x_51);
x_53 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_53, 0, x_48);
lean_ctor_set(x_53, 1, x_52);
x_54 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_54, 0, x_53);
lean_ctor_set_uint8(x_54, sizeof(void*)*1, x_12);
return x_54;
}
}
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_instReprSchemaContext_repr___redArg(x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_instReprSchemaContext_repr___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_IVI_instReprSchemaContext_repr(x_1, x_2);
lean_dec(x_2);
return x_3;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext___closed__0() {
_start:
{
lean_object* x_1; 
x_1 = lean_alloc_closure((void*)(l_IVI_instReprSchemaContext_repr___boxed), 2, 0);
return x_1;
}
}
static lean_object* _init_l_IVI_instReprSchemaContext() {
_start:
{
lean_object* x_1; 
x_1 = l_IVI_instReprSchemaContext___closed__0;
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_ctorIdx(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_unsigned_to_nat(0u);
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_ctorIdx___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_IVI_SchemaLaw_ctorIdx(x_1);
lean_dec_ref(x_1);
return x_2;
}
}
LEAN_EXPORT double l_IVI_SchemaLaw_default___lam__0(lean_object* x_1) {
_start:
{
lean_object* x_2; double x_3; 
x_2 = lean_ctor_get(x_1, 2);
x_3 = l_IVI_dirNorm(x_2);
return x_3;
}
}
static lean_object* _init_l_IVI_SchemaLaw_default() {
_start:
{
lean_object* x_1; 
x_1 = lean_alloc_closure((void*)(l_IVI_SchemaLaw_default___lam__0___boxed), 1, 0);
return x_1;
}
}
LEAN_EXPORT lean_object* l_IVI_SchemaLaw_default___lam__0___boxed(lean_object* x_1) {
_start:
{
double x_2; lean_object* x_3; 
x_2 = l_IVI_SchemaLaw_default___lam__0(x_1);
lean_dec_ref(x_1);
x_3 = lean_box_float(x_2);
return x_3;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Kakeya_Core(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SVObj(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_SchemaLaw(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Kakeya_Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SVObj(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_instReprSchemaContext_repr___redArg___closed__0 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__0();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__0);
l_IVI_instReprSchemaContext_repr___redArg___closed__1 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__1();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__1);
l_IVI_instReprSchemaContext_repr___redArg___closed__2 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__2();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__2);
l_IVI_instReprSchemaContext_repr___redArg___closed__3 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__3();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__3);
l_IVI_instReprSchemaContext_repr___redArg___closed__4 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__4();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__4);
l_IVI_instReprSchemaContext_repr___redArg___closed__5 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__5();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__5);
l_IVI_instReprSchemaContext_repr___redArg___closed__6 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__6();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__6);
l_IVI_instReprSchemaContext_repr___redArg___closed__7 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__7();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__7);
l_IVI_instReprSchemaContext_repr___redArg___closed__8 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__8();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__8);
l_IVI_instReprSchemaContext_repr___redArg___closed__9 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__9();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__9);
l_IVI_instReprSchemaContext_repr___redArg___closed__10 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__10();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__10);
l_IVI_instReprSchemaContext_repr___redArg___closed__11 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__11();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__11);
l_IVI_instReprSchemaContext_repr___redArg___closed__12 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__12();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__12);
l_IVI_instReprSchemaContext_repr___redArg___closed__13 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__13();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__13);
l_IVI_instReprSchemaContext_repr___redArg___closed__14 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__14();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__14);
l_IVI_instReprSchemaContext_repr___redArg___closed__15 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__15();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__15);
l_IVI_instReprSchemaContext_repr___redArg___closed__16 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__16();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__16);
l_IVI_instReprSchemaContext_repr___redArg___closed__17 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__17();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__17);
l_IVI_instReprSchemaContext_repr___redArg___closed__18 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__18();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__18);
l_IVI_instReprSchemaContext_repr___redArg___closed__19 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__19();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__19);
l_IVI_instReprSchemaContext_repr___redArg___closed__20 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__20();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__20);
l_IVI_instReprSchemaContext_repr___redArg___closed__21 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__21();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__21);
l_IVI_instReprSchemaContext_repr___redArg___closed__22 = _init_l_IVI_instReprSchemaContext_repr___redArg___closed__22();
lean_mark_persistent(l_IVI_instReprSchemaContext_repr___redArg___closed__22);
l_IVI_instReprSchemaContext___closed__0 = _init_l_IVI_instReprSchemaContext___closed__0();
lean_mark_persistent(l_IVI_instReprSchemaContext___closed__0);
l_IVI_instReprSchemaContext = _init_l_IVI_instReprSchemaContext();
lean_mark_persistent(l_IVI_instReprSchemaContext);
l_IVI_SchemaLaw_default = _init_l_IVI_SchemaLaw_default();
lean_mark_persistent(l_IVI_SchemaLaw_default);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
