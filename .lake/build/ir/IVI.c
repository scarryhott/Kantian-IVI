// Lean compiler output
// Module: IVI
// Imports: Init IVI.Core IVI.Pure IVI.Operators IVI.Domain IVI.System IVI.C3Model IVI.Intangible IVI.Invariant IVI.FixedPoint IVI.Kakeya IVI.Harmonics IVI.KantLimit
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
lean_object* initialize_IVI_FixedPoint(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Kakeya(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_Harmonics(uint8_t builtin, lean_object*);
lean_object* initialize_IVI_KantLimit(uint8_t builtin, lean_object*);
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
res = initialize_IVI_FixedPoint(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Kakeya(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_Harmonics(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_IVI_KantLimit(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
