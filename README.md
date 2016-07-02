# markdown-cpp

*brought to you by Andrew Sveikauskas, a.l.sveikauskas @ gmail.com*

markdown-cpp is a rather spartan static site generator built on the C preprocessor, make(1)
and markdown.

The rationale is to write some simple markdown, but also get some minor flexibility from
having #define and #include, and end up with something reasonably approaching a website.

The dependencies are just cpp(1), make(1), and perl, i.e. things you already have on your
system.

## Usage

The original idea was to plop down this source tree on into your web server, start writing
index.md-cpp, and type "make".

You will need to edit the Makefile and specify all the files you want to generate in the FILES
variable at the top of the file.

There is a make rule to generate .html files based on an .md-cpp dependency.  So for example
for index.html, you will name the file index.md-cpp.

The "include" directory at the root of this tree will be on the include path.

The Makefile will chmod the source files so that they are not accessible to the public.

If you want to snapshot your output or your source, there is a "make tar" target.
src.tar.gz will be the md-cpp files and all the scripts.  site.tar.gz will be the output,
ready to copy and untar on the server.

## Weird quirks

As you might guess, trying to run a C preprocessor on markdown files leads to some
interesting conflicts.

* Markdown h-tags require a leading # character.  C preprocessor directives also use this.
Further, the cpp(1) will inject more leading-# lines into the output.
To work around this we put in place the following restrictions:
   * A C preprocessor directive must not have leading whitespace before the '#', or between the
     '#' and the directive (eg. '# include' is treated as a markdown heading).
   * You cannot use markdown h-tags inside an #include-ed file.  Sorry.
   * Unlike "typical" markdown, you must have a space after '#', again to distinguish between
     preprocessor directives.
   * Any leading space before '#' will be ignored and the line will be treated as markdown.
   * The markdown h-tags should not look like cpp(1) output (eg: # 1 "file.c")
* Markdown injects a bunch of &lt;p&gt; tags, so you can't really have the leading &lt;html&gt;
tag etc.  More generally, there is a need to escape, or force "non-markdown" mode.
For this, we start that mode with a line containing NOMARKDOWN and ending in END_NOMARKDOWN.
eg.:
<blockquote>
<pre><code>
    NOMARKDOWN
    &lt;html&gt;&lt;head&gt;&lt;title&gt;Page title&lt;/title&gt;&lt;/head>&lt;body&gt;
    END_NOMARKDOWN
    
    My text goes here.  It will get a &lt;p&gt; tag.
    
    NOMARKDOWN
    &lt;/body&gt;
    &lt;/html&gt;
    END_NOMARKDOWN
</code><pre>
</blockquote>
* The Makefile doesn't properly track dependencies.  For a C project I might add a "make depend"
target which calls gcc -MM to generate lines in a makefile.  I haven't done that here.  A manual
clean build every time you change a header should suffice.
* There are some strings that you won't be able to type in your markdown, like `__STDC_HOSTED__`.
* The C preprocessor sometimes introduces whitespace.  This will have no affect on rendering but
may bother you.
