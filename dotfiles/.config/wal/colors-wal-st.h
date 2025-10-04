const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#020705", /* black   */
  [1] = "#275646", /* red     */
  [2] = "#346D4C", /* green   */
  [3] = "#4D7450", /* yellow  */
  [4] = "#4B942E", /* blue    */
  [5] = "#5E9A5F", /* magenta */
  [6] = "#8DB064", /* cyan    */
  [7] = "#c9dca9", /* white   */

  /* 8 bright colors */
  [8]  = "#8c9a76",  /* black   */
  [9]  = "#275646",  /* red     */
  [10] = "#346D4C", /* green   */
  [11] = "#4D7450", /* yellow  */
  [12] = "#4B942E", /* blue    */
  [13] = "#5E9A5F", /* magenta */
  [14] = "#8DB064", /* cyan    */
  [15] = "#c9dca9", /* white   */

  /* special colors */
  [256] = "#020705", /* background */
  [257] = "#c9dca9", /* foreground */
  [258] = "#c9dca9",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
