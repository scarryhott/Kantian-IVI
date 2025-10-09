// Lean compiler output
// Module: IVI
// Imports: Init IVI.Core IVI.Pure IVI.Operators IVI.Domain IVI.System IVI.C3Model IVI.Intangible IVI.Invariant IVI.Collapse IVI.FixedPoint IVI.Kakeya IVI.KakeyaBounds IVI.KakeyaAssemble IVI.Bounds IVI.Relax IVI.FloatSpec IVI.SVObj IVI.SchemaLaw IVI.Will IVI.Harmonics IVI.KantLimit IVI.Fractal
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
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Core(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Pure(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Operators(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Domain(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_System(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_C3Model(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Intangible(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Invariant(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Collapse(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_FixedPoint(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Kakeya(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_KakeyaBounds(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_KakeyaAssemble(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Bounds(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Relax(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_FloatSpec(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SVObj(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_SchemaLaw(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Will(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Harmonics(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_KantLimit(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Fractal(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_IVI(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Pure(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Operators(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Domain(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_System(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_C3Model(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Intangible(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Invariant(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Collapse(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_FixedPoint(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Kakeya(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_KakeyaBounds(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_KakeyaAssemble(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Bounds(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Relax(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_FloatSpec(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SVObj(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_SchemaLaw(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Will(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Harmonics(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_KantLimit(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Fractal(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
