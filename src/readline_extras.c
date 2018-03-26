/* ----------------------------------------------------------------
 * readline_extras.c 
 *
 * Copyright (C) 2018 by Matthew Love <matthew.love@colorado.edu>
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this file.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * --------------------------------------------------------------*/

#include <stdio.h> 
#include <libguile.h>

#include <readline/readline.h>
#include <readline/history.h>

SCM_DEFINE (scm_rl_parse_and_bind, "%rl-parse-and-bind", 1, 0, 0,
	    (SCM scm_config_line),
	    "Parse line as if it had been read from the inputrc file and perform any key bindings and variable assignments found.")
{
  char *line;
  int status;

  line = scm_to_locale_string( scm_config_line );

  status = rl_parse_and_bind (line);

  if (status == 0) {
    return ( SCM_BOOL_T );
  } else {
    return ( SCM_BOOL_F );
  }
    
}

/* SCM */
/* scm_readline_function (scm func) */
/* { */

/* } */

void
scm_init_readline_extras ()
{
  
  //scm_c_define_gsubr ("%rl-parse-and-bind", 1, 0, 0, scm_rl_parse_and_bind);  

#ifndef SCM_MAGIC_SNARFER
#include "readline_extras.x"
#endif

  scm_add_feature ("readline-extras");
  
}
