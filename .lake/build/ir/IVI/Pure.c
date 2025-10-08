// Lean compiler output
// Module: IVI.Pure
// Imports: Init IVI.Core IVI.SchematismEvidence IVI.Invariant IVI.System
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
static lean_object* l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_;
static lean_object* l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_;
static lean_object* l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_;
LEAN_EXPORT lean_object* l_IVI_reprSubject____x40_IVI_Pure___hyg_17_(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
static lean_object* l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_;
static lean_object* l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_;
static lean_object* l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_;
lean_object* lean_nat_to_int(lean_object*);
LEAN_EXPORT lean_object* l_IVI_instReprSubject(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_instReprSubject___redArg(lean_object*, lean_object*);
static lean_object* l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_;
static lean_object* l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_;
LEAN_EXPORT lean_object* l_IVI_Axioms_reciprocity(lean_object*);
LEAN_EXPORT lean_object* l_IVI_reprSubject____x40_IVI_Pure___hyg_17____boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_IVI_Axioms_diagonalReciprocity(lean_object*);
static lean_object* l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_;
static lean_object* _init_l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("{ ", 2, 2);
return x_1;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked(" }", 2, 2);
return x_1;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_unsigned_to_nat(2u);
x_2 = lean_nat_to_int(x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = lean_box(0);
x_2 = l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_;
x_3 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_3, 0, x_2);
lean_ctor_set(x_3, 1, x_1);
return x_3;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_;
x_2 = lean_alloc_ctor(3, 1, 0);
lean_ctor_set(x_2, 0, x_1);
return x_2;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_;
x_2 = l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_;
x_3 = lean_alloc_ctor(5, 2, 0);
lean_ctor_set(x_3, 0, x_2);
lean_ctor_set(x_3, 1, x_1);
return x_3;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_;
x_2 = l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_;
x_3 = lean_alloc_ctor(4, 2, 0);
lean_ctor_set(x_3, 0, x_2);
lean_ctor_set(x_3, 1, x_1);
return x_3;
}
}
static lean_object* _init_l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; uint8_t x_4; 
x_1 = lean_box(0);
x_2 = l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_;
x_3 = lean_alloc_ctor(6, 1, 1);
lean_ctor_set(x_3, 0, x_2);
x_4 = lean_unbox(x_1);
lean_ctor_set_uint8(x_3, sizeof(void*)*1, x_4);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_reprSubject____x40_IVI_Pure___hyg_17_(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_;
return x_6;
}
}
LEAN_EXPORT lean_object* l_IVI_reprSubject____x40_IVI_Pure___hyg_17____boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; 
x_6 = l_IVI_reprSubject____x40_IVI_Pure___hyg_17_(x_1, x_2, x_3, x_4, x_5);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
lean_dec(x_2);
return x_6;
}
}
LEAN_EXPORT lean_object* l_IVI_instReprSubject___redArg(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = lean_alloc_closure((void*)(l_IVI_reprSubject____x40_IVI_Pure___hyg_17____boxed), 5, 3);
lean_closure_set(x_3, 0, lean_box(0));
lean_closure_set(x_3, 1, x_1);
lean_closure_set(x_3, 2, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* l_IVI_instReprSubject(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = lean_alloc_closure((void*)(l_IVI_reprSubject____x40_IVI_Pure___hyg_17____boxed), 5, 3);
lean_closure_set(x_4, 0, lean_box(0));
lean_closure_set(x_4, 1, x_2);
lean_closure_set(x_4, 2, x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_IVI_Axioms_diagonalReciprocity(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_box(0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_IVI_Axioms_reciprocity(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_box(0);
return x_2;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Core(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SchematismEvidence(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Invariant(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_System(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI_Pure(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SchematismEvidence(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Invariant(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_System(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__0____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__1____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__2____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__3____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__4____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__5____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__6____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__7____x40_IVI_Pure___hyg_17_);
l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_ = _init_l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_();
lean_mark_persistent(l_IVI_reprSubject___closed__8____x40_IVI_Pure___hyg_17_);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
