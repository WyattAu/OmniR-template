#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/*
 * Register native routines as required by "Writing R Extensions",
 * section 5.4.1. Registration removes the corresponding `R CMD check`
 * NOTE and disables dynamic symbol lookup, so only routines listed
 * here can be called from R.
 */
extern SEXP omnicore_fibonacci(SEXP);

static const R_CallMethodDef call_methods[] = {
    {"omnicore_fibonacci", (DL_FUNC) &omnicore_fibonacci, 1},
    {NULL, NULL, 0}
};

void R_init_omnicore(DllInfo *dll) {
    R_registerRoutines(dll, NULL, call_methods, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
