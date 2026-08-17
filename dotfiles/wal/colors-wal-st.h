const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#010402", /* black   */
  [1] = "#214944", /* red     */
  [2] = "#593c35", /* green   */
  [3] = "#366d42", /* yellow  */
  [4] = "#7f8c7c", /* blue    */
  [5] = "#67a35c", /* magenta */
  [6] = "#84a484", /* cyan    */
  [7] = "#9ca19e", /* white   */

  /* 8 bright colors */
  [8]  = "#3a443e",  /* black   */
  [9]  = "#214944",  /* red     */
  [10] = "#593c35", /* green   */
  [11] = "#366d42", /* yellow  */
  [12] = "#7f8c7c", /* blue    */
  [13] = "#67a35c", /* magenta */
  [14] = "#84a484", /* cyan    */
  [15] = "#9ca19e", /* white   */

  /* special colors */
  [256] = "#010402", /* background */
  [257] = "#9ca19e", /* foreground */
  [258] = "#9ca19e",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
