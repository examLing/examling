argument "text" is missing, with no default
Traceback:
62: stopifnot(typeof(x) == "language")
61: call_type(call)
60: call_name(call)
59: (function (call, fn) 
    {
        if (is_quosure(call)) {
            call <- quo_get_expr(call)
            if (!is_call(call)) {
                return(trace_context())
            }
        }
        if (call_print_fine_type(call) != "call") {
            return(trace_context())
        }
        namespace <- call_ns(call)
        name <- call_name(call)
        if (is_null(name)) {
            return(trace_context())
        }
        if (!is_null(namespace)) {
            return(trace_context(namespace = namespace, scope = as_string(call[[1]][[1]])))
        }
        if (is_environment(fn)) {
            fn <- get(name, envir = fn, mode = "function")
        }
        else if (is_function(fn)) {
            fn <- fn
        }
        else {
            fn <- sys.function(fn)
        }
        env <- fn_env(fn)
        top <- topenv(env)
        if (is_reference(env, global_env())) {
            namespace <- NA
            scope <- "global"
        }
        else if (is_namespace(top)) {
            namespace <- ns_env_name(top)
            if (ns_exports_has(top, name)) {
                scope <- "::"
            }
            else if (env_has(top, name)) {
                scope <- ":::"
            }
            else {
                scope <- "local"
            }
        }
        else {
            namespace <- NA
            scope <- NA
        }
        trace_context(namespace = namespace, scope = scope)
    })(dots[[1L]][[25L]], dots[[2L]][[25L]])
58: mapply(.f, .x, .y, MoreArgs = list(...), SIMPLIFY = FALSE)
57: map2(calls, seq_along(calls), call_trace_context)
56: trace_back(top = top, bottom = bottom)
55: cnd_entrace(cnd)
54: (function (cnd) 
    {
        if (!is.null(matched) || !matches(cnd)) {
            return()
        }
        if (can_entrace(cnd)) {
            cnd <- cnd_entrace(cnd)
        }
        matched <<- cnd
        if (inherits(cnd, "message") || inherits(cnd, "warning")) {
            cnd_muffle(cnd)
        }
        else if (inherits(cnd, "error") || inherits(cnd, "skip")) {
            return_from(tl, cnd)
        }
    })(list(message = "Spreadsheet formatting cannot be read; use markdown-style formatting instead.", 
        call = rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, 
            log_file = log_file, url = url)))
53: doWithOneRestart(return(expr), restart)
52: withOneRestart(expr, restarts[[1L]])
51: withRestarts({
        .Internal(.signalCondition(simpleWarning(msg, call), msg, 
            call))
        .Internal(.dfltWarn(msg, call))
    }, muffleWarning = function() NULL)
50: .signalSimpleWarning("Spreadsheet formatting cannot be read; use markdown-style formatting instead.", 
        base::quote(rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, 
            log_file = log_file, url = url)))
49: warning(paste0("Spreadsheet formatting cannot be read; use markdown-style ", 
        "formatting instead.")) at xlsx2rmd.R#66
48: rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, log_file = log_file, 
        url = url)
47: tryCatchList(expr, classes, parentenv, handlers)
46: tryCatch(rexamsll::xlsx2rmd(xlsx_file, output_dir, sheet = sheet, 
        log_file = log_file, url = url), finally = {
        unlink(xlsx_file)
        rexamsll::end_logs()
    }) at google2rmd.R#69
45: google2rmd(url, "Example", sheet = "Truth Conditions")
44: eval_bare(quo_get_expr(.quo), quo_get_env(.quo))
43: withCallingHandlers(expr, condition = function(cnd) {
        if (!is.null(matched) || !matches(cnd)) {
            return()
        }
        if (can_entrace(cnd)) {
            cnd <- cnd_entrace(cnd)
        }
        matched <<- cnd
        if (inherits(cnd, "message") || inherits(cnd, "warning")) {
            cnd_muffle(cnd)
        }
        else if (inherits(cnd, "error") || inherits(cnd, "skip")) {
            return_from(tl, cnd)
        }
    })
42: .capture(act$val <- eval_bare(quo_get_expr(.quo), quo_get_env(.quo)), 
        ...)
41: quasi_capture(enquo(object), label, capture_matching_condition, 
        matches = matcher)
40: expect_condition_matching("warning", {
        {
            object
        }
    }, regexp = regexp, class = class, ..., inherit = inherit, info = info, 
        label = label, trace_env = caller_env())
39: expect_warning(google2rmd(url, "Example", sheet = "Truth Conditions"), 
        paste0("Spreadsheet formatting cannot be read; use markdown-style ", 
            "formatting instead."))
38: withCallingHandlers(expr, warning = function(w) if (inherits(w, 
        classes)) tryInvokeRestart("muffleWarning"))
37: suppressWarnings(expect_warning(google2rmd(url, "Example", sheet = "Truth Conditions"), 
        paste0("Spreadsheet formatting cannot be read; use markdown-style ", 
            "formatting instead."))) at test-google2rmd.R#9
36: eval(code, test_env)
35: eval(code, test_env)
34: withCallingHandlers({
        eval(code, test_env)
        if (!handled && !is.null(test)) {
            skip_empty()
        }
    }, expectation = handle_expectation, skip = handle_skip, warning = handle_warning, 
        message = handle_message, error = handle_error)
33: doTryCatch(return(expr), name, parentenv, handler)
32: tryCatchOne(expr, names, parentenv, handlers[[1L]])
31: tryCatchList(expr, names[-nh], parentenv, handlers[-nh])
30: doTryCatch(return(expr), name, parentenv, handler)
29: tryCatchOne(tryCatchList(expr, names[-nh], parentenv, handlers[-nh]), 
        names[nh], parentenv, handlers[[nh]])
28: tryCatchList(expr, classes, parentenv, handlers)
27: tryCatch(withCallingHandlers({
        eval(code, test_env)
        if (!handled && !is.null(test)) {
            skip_empty()
        }
    }, expectation = handle_expectation, skip = handle_skip, warning = handle_warning, 
        message = handle_message, error = handle_error), error = handle_fatal, 
        skip = function(e) {
        })
26: test_code(desc, code, env = parent.frame(), reporter = reporter)
25: test_that("Load sheet by name", {
        unlink("Example/*")
        url <- paste0("docs.google.com/spreadsheets/d/", "1r3cH6oVKfEm6OiYj8uSk4YidVJs4a-xgSF5-w3iBbQ4", 
            collapse = "")
        suppressWarnings(expect_warning(google2rmd(url, "Example", 
            sheet = "Truth Conditions"), paste0("Spreadsheet formatting cannot be read; use markdown-style ", 
            "formatting instead.")))
        suppressWarnings(google2rmd(url, "Example", sheet = "Lambda Calculus"))
        expect_gt(length(list.files("Example")), 0)
    }) at test-google2rmd.R#1
24: eval(code, test_env)
23: eval(code, test_env)
22: withCallingHandlers({
        eval(code, test_env)
        if (!handled && !is.null(test)) {
            skip_empty()
        }
    }, expectation = handle_expectation, skip = handle_skip, warning = handle_warning, 
        message = handle_message, error = handle_error)
21: doTryCatch(return(expr), name, parentenv, handler)
20: tryCatchOne(expr, names, parentenv, handlers[[1L]])
19: tryCatchList(expr, names[-nh], parentenv, handlers[-nh])
18: doTryCatch(return(expr), name, parentenv, handler)
17: tryCatchOne(tryCatchList(expr, names[-nh], parentenv, handlers[-nh]), 
        names[nh], parentenv, handlers[[nh]])
16: tryCatchList(expr, classes, parentenv, handlers)
15: tryCatch(withCallingHandlers({
        eval(code, test_env)
        if (!handled && !is.null(test)) {
            skip_empty()
        }
    }, expectation = handle_expectation, skip = handle_skip, warning = handle_warning, 
        message = handle_message, error = handle_error), error = handle_fatal, 
        skip = function(e) {
        })
14: test_code(NULL, exprs, env)
13: source_file(path, child_env(env), wrap = wrap)
12: FUN(X[[i]], ...)
11: lapply(test_paths, test_one_file, env = env, wrap = wrap)
10: doTryCatch(return(expr), name, parentenv, handler)
9: tryCatchOne(expr, names, parentenv, handlers[[1L]])
8: tryCatchList(expr, classes, parentenv, handlers)
7: tryCatch(code, testthat_abort_reporter = function(cnd) {
       cat(conditionMessage(cnd), "\n")
       NULL
   })
6: with_reporter(reporters$multi, lapply(test_paths, test_one_file, 
       env = env, wrap = wrap))
5: test_files(test_dir = test_dir, test_package = test_package, 
       test_paths = test_paths, load_helpers = load_helpers, reporter = reporter, 
       env = env, stop_on_failure = stop_on_failure, stop_on_warning = stop_on_warning, 
       wrap = wrap, load_package = load_package)
4: test_files(test_dir = path, test_paths = test_paths, test_package = package, 
       reporter = reporter, load_helpers = load_helpers, env = env, 
       stop_on_failure = stop_on_failure, stop_on_warning = stop_on_warning, 
       wrap = wrap, load_package = load_package, parallel = parallel)
3: test_dir(test_path, package = package, reporter = reporter, ..., 
       load_package = if (package != "testthat") "source" else "none")
2: testthat::test_local(pkg$path, filter = filter, stop_on_failure = stop_on_failure, 
       ...)
1: devtools::test(reporter = praiseless_reporter)

