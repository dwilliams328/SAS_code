/********************************************************************************
* Program Name: proc_means_transpose.sas
* Description: Transpose proc means dataset output to reflect result print
               (PACKAGES candidate).

* PARAMETERS(Space delimited):
* inds: Input dataset
* var_list: Input dataset variables to be analyzed
* <class_list>: Optional parameter for category variables in dataset to provide
              subgroup combinations for the &var_list..
********************************************************************************/
%macro means_transpose(inds=,var_list=,class_list=);
    %local stat_vars stat_count var_count stat combine_var;
    /* When the 'out=' options is enabled, by default proc means outputs a concise
    dataset containing the same info as a result print, but in a different layout.

    This sequence of steps transposes the output exactly like the result output, but
    as a dataset. */
    proc means data=&inds. n mean p5 p25 p50 p75 p95 nway missing maxdec=2;
        var &var_list.;
        class &class_list.;
        output out=work.proc_means_output(drop=_TYPE_ _FREQ_)
                n(&var_list.)=
                mean(&var_list.)=
                p5(&var_list.)=
                p25(&var_list.)=
                p50(&var_list.)=
                p75(&var_list.)=
                p95(&var_list.)=/autoname;
    run;

    title "Notice how the proc means outputs the dataset different from the
 output results table";
    title2 "This table will be transposed";
    proc print data=work.proc_means_output(obs=5);
    run;
    title;

    /* list of descriptive statistics for analysis variables. */
    %let stat_vars = n mean p5 p25 p50 p75 p95;

    %let stat_count = %sysfunc(countw(&stat_vars.,' '));
    %let var_count = %sysfunc(countw(&var_list.,' '));

    %do k = 1 %to &stat_count.; /* for each stat var loop */

        /* Single stat var base on &k. positions. */
        %let stat = %scan(&stat_vars.,&k.);
        %local &stat.;

        /* Create macro vars containing the names analysis variables stats
        outputted by proc means. */
        %do i=1 %to &var_count.; /* for each variable(analysis var) in &var_list. */
            %local &&stat.&i.;
            %let &&stat.&i. = %sysfunc(catx('',%scan(&var_list.,&i.),"_&stat. "));
            %let &&stat.&i. = %sysfunc(compress(&&&stat.&i.,"'"));

            %put By stat var: for each input analysis variable append stat vars suffix - &&&stat.&i.;

        %end;

        /* For each macro variable created, combine them respective to their group. */
        /* There will always be at least on variable, so assign that outside of the do
        while loop */
        %let combine_var = &&&stat.1;
        %let p=2;

        /* Cycle over list of analysis variables, and append one after the other */
        %do %while (&p. <= &var_count.);
            %let combine_var = %sysfunc(catx(' ',&combine_var.,&&&stat.&p.));
            %let p = %eval(&p.+1);
        %end;

        /* Strip off single quote and print to log for validation */
        %let &stat. = %sysfunc(compress(&combine_var.,"'"));
        %put  ;
        %put List of analysis variables in a single macro var - &&&stat.;
        %put  ;
    %end;

    %put Notice the values here correspond to the name of the stat vars from the
 proc means dataset output(compare with proc print);
     %put ;
    %put &n.;
    %put &mean.;
    %put &p5.;
    %put &p25.;
    %put &p50.;
    %put &p75.;
    %put &p95.;

    /* The proc means step outputs the results horizontally. The datastep will
    flip/transpose the data so that it displays vertically. DELETE OLD VAR NAMES AFTERWARDS */
    data work.proc_means_output_final(drop=&n. &mean. &p5. &p25. &p50. &p75. &p95.);
        set work.proc_means_output;

        length variable $20.;
        /* Create array of stat variables names. These will be read in, and output
        to separate observation by SAS. */
        array n{*} &n.;
        array m{*} &mean.;
        array p5{*} &p5.;
        array p25{*} &p25.;
        array p50{*} &p50.;
        array p75{*} &p75.;
        array p95{*} &p95.;

        do i=1 to dim(n);

            j = i;
            do while (j ^= 0);
                /* set variable name base off position in array list. */
                    select;
                        %do m=1 %to &var_count.;
                        when (j=&m.) Variable = "%scan(&var_list.,&m.)";
                        %end;
                    end;
                j = 0;
            end;

            /* read in stat values for current iteration analysis variable. Output record
            after assigning to stat variable. */
            Ncount= n{i};
            Mean= m{i};
            P5p= p5{i};
            P25p= p25{i};
            P50p= p50{i};
            P75p= p75{i};
            P95p= p95{i};
            output;
        end;
        drop i j;
    run;

%mend means_transpose;

/* Enable for testing */
%*means_transpose(inds=sashelp.baseball,var_list=nHits nHome nRuns nAtBat,
 class_list=division position);

