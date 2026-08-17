static const char norm_fg[] = "#9ca19e";
static const char norm_bg[] = "#010402";
static const char norm_border[] = "#3a443e";

static const char sel_fg[] = "#9ca19e";
static const char sel_bg[] = "#593c35";
static const char sel_border[] = "#9ca19e";

static const char urg_fg[] = "#9ca19e";
static const char urg_bg[] = "#214944";
static const char urg_border[] = "#214944";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
