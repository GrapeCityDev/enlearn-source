<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/lesson">
    <html>
      <head>
        <link href="/lessons/xslt/css/lesson.css" rel="stylesheet" type="text/css"/>
        <link href="/lessons/xslt/css/lessonPlanOverrides.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
        </script>
        <!-- Lines below are only for viewing locally, xml subdirectory is sibling of css.  Once converted to HTML, css is a child (lines above)-->
      <!--   <link href="../../EnlearnApp/Assets/copilot/css/lesson.css" rel="stylesheet" type="text/css"/>
        <link href="../../EnlearnApp/Assets/copilot/css/lessonPlanOverrides.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="../../EnlearnApp/Assets/copilot/js/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
        </script> -->
      </head>
      <body>
        <xsl:comment> [LESSON] </xsl:comment>
        <div id="headerTitle" class="banner">
          Lesson: <xsl:value-of select="@name"/> - <xsl:value-of select="@id"/>
        </div>
        <div class="lesson">
          <xsl:attribute name="data-name">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <!--   Add a student connection screen as page 1, 
          Be careful when adding and subtracting page titles and module titles because
          there is sequential adjustments of these in the XMLtoDB.cs (used to be done by javascript).  
          Changing the title below from a module title to a page title had the affect of throwing the titles off by one-->
          <xsl:call-template name="insertActivityComment"/>
          <xsl:call-template name="insertActivityCounter">
            <xsl:with-param name="counter" select="1" />
          </xsl:call-template>

          <xsl:call-template name="insertPageTitleFromParameter">
            <xsl:with-param name="actualText" select="concat(@name,' - ',@id,' : Connected')" />
          </xsl:call-template>
          
          <div data-roster="" data-type="connectionStatus"></div>
          
          <!-- This set of tags for first page only (Intro, how to read)-->
          <xsl:call-template name="insertActivityComment"/>
          <xsl:call-template name="insertActivityCounter">
            <xsl:with-param name="counter" select="2" />
          </xsl:call-template>

          <xsl:call-template name="insertPageTitleFromParameter">
            <xsl:with-param name="actualText" select="concat(@name,' - ',@id,' : Introduction')" />
          </xsl:call-template>
          <div class="top_material" id="0">
            <h3>Goals:</h3>
            <ul>
              <xsl:for-each select="objective">
                <li>
                  <xsl:value-of select="."/>
                </li>
              </xsl:for-each>
            </ul>
            <h3>Prior Knowledge Required:</h3>
            <ul>
              <xsl:for-each select="prerequisites/prerequisite">
                <li>
                  <xsl:value-of select="@name"/>
                </li>
              </xsl:for-each>
            </ul>
            <p></p>
            Vocabulary:
            <xsl:for-each select="vocabulary/termdefinition">
              <xsl:if test="position()!=1">, </xsl:if>
              <xsl:value-of select="term"/>
            </xsl:for-each>
            <p></p>
            <hr></hr>
            <div class="teachernote"> How to read the lesson:</div>
            <xsl:call-template name="insertModuleTitleFromParameter">
              <xsl:with-param name="actualText" select="'Large text highlights new concept'" />
            </xsl:call-template>
            <div class="teacher-display" id="exempt_top_material">
              <div class="teachernote" type="pre"> Text outside the rectangles are additional notes and instructions for the teacher.</div>
              <div class="slide">  Rectangles are slides or activities being displayed by the demo tablet. Most slides should be read or paraphrased.  Additional discussion and real-world connections are encouraged. </div>
              <div class="teachernote">
                Instruction is above/below the slide/activity depending whether it is something that should be done earlier or later in the discussion.
              </div>
            </div>
            <hr></hr>
          </div>
          <!-- end of top_material -->

          <!-- End of first page only -->

           
            <xsl:for-each select="module">
            <!-- Get module name and store in variable to put inside a display wrapper -->
            <xsl:variable name="moduleHeading" select="@name"/>
            
            <xsl:for-each select="teacher-display">
              
              <xsl:call-template name="insertActivityComment"/>
              
              <xsl:call-template name="insertActivityCounter">
                <xsl:with-param name="counter" select="count(preceding::teacher-display)+3" />
              </xsl:call-template>
              <xsl:call-template name="insertAssignmentNumberButton"/>
              <xsl:if test="position()=1">
                <xsl:call-template name="insertModuleTitleFromParameter">
                  <xsl:with-param name="actualText" select="$moduleHeading" />
                </xsl:call-template>
              </xsl:if>
              <div class="teacher-display">
                <xsl:call-template name="setDividerBasedOnChildren"/>
                <xsl:apply-templates/>
              </div>

            </xsl:for-each>
            <!-- teacher-display -->
          </xsl:for-each>
          <!-- module -->
        </div>
        <xsl:call-template name="insertActivityComment"/>
        <xsl:call-template name="insertPageTitleFromParameter">
          <xsl:with-param name="actualText" select="'End of Lesson'" />
        </xsl:call-template>
        <div class="teacher-display">
          <div id="endOfLessonReminder" class="endOfLessonReminder">
            End of Lesson.<br></br>
            Click End Lesson button in upper left.
          </div>
        </div>
        <div id="footerTitle" class="banner">
          Lesson: <xsl:value-of select="@name"/> - <xsl:value-of select="@id"/>
        </div>
        <xsl:comment> [LESSON END] </xsl:comment>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="setDividerBasedOnChildren">
    <xsl:choose>
      <xsl:when test="misc|termdefinition|forced-slide-image-title">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Slide'" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="forced-slide-instruction-title">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Instruction Only'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="demo">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Demo'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="guided">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Guided'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="exercise">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Exercise'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="workbook">
        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Workbook'" />
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>

        <xsl:call-template name="insertDividerFromParameter">
          <xsl:with-param name="actualText" select="'Generic Divider'" />
        </xsl:call-template>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="slideWrapper">
    <div class="slide" data-content="slide">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="askclass | misc">
    <xsl:call-template name="insertPageTitleFromParameter">
      <xsl:with-param name="actualText" select="concat(substring(.,1,20),substring-before(substring(.,21,40),' '),'...')" />
    </xsl:call-template>
    <xsl:call-template name="slideWrapper"/>
  </xsl:template>

  <xsl:template match="termdefinition">
    <xsl:call-template name="insertPageTitleFromParameter">
      <xsl:with-param name="actualText" select="term" />
    </xsl:call-template>
    <div class="slide" data-content="slide">
      <div class="termdefinition">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="term">
    <div class="termLabel">Term:</div>
    <div class="term">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="definition">
    <div class="definitionLabel">Definition:</div>
    <div class="definition">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example">
      
      <div class="exampleTermLabel">Example:</div>
      <div class="exampleTerm">
       <xsl:copy-of select="@*"/>
       <xsl:value-of select="." disable-output-escaping="yes" />
      </div>
  </xsl:template>

  <xsl:template name="insertActivityComment">
    <xsl:text>&#10;</xsl:text>
    <!-- Line breaks for the comment tag used by Yanko -->
    <xsl:comment> [ACTIVITY] </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="insertActivityCounter">
    <xsl:param name="counter" select="'default value'"/>
    <A id="{$counter}"></A>
  </xsl:template>


  <xsl:template name="reminderLabelForDemoAndGuided">
    <!-- START: BIG REMINDER FOR FIRST TWO? -->
    <div class="prompt alert alert-block alert-info" data-prompt="">
      Use the Demo Tablet!
    </div>
    <!-- END: BIG REMINDER FOR FIRST TWO? -->
  </xsl:template>


  <!-- this can probably be refactored and made part of the insert divider-->
  <xsl:template name="insertAssignmentNumberButton">
    <xsl:if test="demo/assignment-name">
      <button data-command="start" class="btn btn-large" data-type="demo">
        <xsl:attribute name="data-assignment-name">
          <xsl:value-of select="demo/assignment-name"/>
        </xsl:attribute>
        Start Demo
      </button>
      <xsl:call-template name="reminderLabelForDemoAndGuided"/>
    </xsl:if>

    <xsl:if test="guided/assignment-name">
      <button data-command="start" class="btn btn-large" data-type="guided">
        <xsl:attribute name="data-assignment-name">
          <xsl:value-of select="guided/assignment-name"/>
        </xsl:attribute>
        Start Guided
      </button>


      <xsl:call-template name="reminderLabelForDemoAndGuided"/>
    </xsl:if>

    <xsl:if test="exercise/assignment-name">


      <button data-command="start" class="btn btn-large" data-type="exercise">
        <xsl:attribute name="data-assignment-name">
          <xsl:value-of select="exercise/assignment-name"/>
        </xsl:attribute>
        Start Exercise
      </button>

    </xsl:if>

    <xsl:if test="workbook/assignment-name">
      <button data-command="start" class="btn btn-large" data-type="exercise">
        <xsl:attribute name="data-assignment-name">
          <xsl:value-of select="workbook/assignment-name"/>
        </xsl:attribute>
        Start Workbook
      </button>

    </xsl:if>
  </xsl:template>

  <xsl:variable name="vLower" select=
 "'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="vUpper" select=
 "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>



  <xsl:template name="insertModuleTitleFromParameter">
    <xsl:param name="actualText" select="'default value'"/>
    <H2 data-module-set-title="" class="module-title">
      <xsl:value-of select="concat(translate(substring($actualText,1,1), $vLower, $vUpper),
          substring($actualText, 2))"/>
    </H2>
  </xsl:template>

  <xsl:template name="insertPageTitleFromParameter">
    <xsl:param name="actualText" select="'default value'"/>
    <H4 data-set-title="" class="page-title">
      <xsl:value-of select="concat(translate(substring($actualText,1,1), $vLower, $vUpper),
          substring($actualText, 2))"/>
    </H4>
  </xsl:template>

  <xsl:template name="insertCommentFromParameter">
    <xsl:param name="actualText" select="'default value'"/>
    <xsl:text>&#10;</xsl:text>
    <!-- Line breaks for the comment tag used by Yanko -->
    <xsl:comment>
      <xsl:text></xsl:text>
      <xsl:value-of select="$actualText"/>
      <xsl:text></xsl:text>
    </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="insertDividerFromParameter">
    <xsl:param name="actualText" select="'default value'"/>
    <div class="display-divider">
      <span class="divider-span-text">
       <xsl:value-of select="$actualText"/> 
       <!-- <xsl:copy-of select="."/> -->
      </span>
    </div>
  </xsl:template>


  <xsl:template name="insertClassNameAsLabel">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <!-- This is where the text actually gets dumped in -->
    </div>
  </xsl:template>
  <xsl:template name="insertClassNameAsLabelPlusContents">
    <xsl:call-template name="insertClassNameAsLabel"/>
    <xsl:call-template name="activityGenericInstruction"/>
  </xsl:template>

  <xsl:template name="activityGenericInstruction">
    <div class="activityGenericInstruction">
      <xsl:choose>
        <xsl:when test="name()='demo'">
          Please use the demo tablet for this activity.
        </xsl:when>
        <xsl:when test="name()='guided'">
          Please use the demo tablet for this activity and the dashboard to monitor student progress.
        </xsl:when>
        <xsl:when test="(name()='exercise') or (name()='workbook')">
          Please use the dashboard to monitor student progress.  Assist individuals as needed.
        </xsl:when>
        <xsl:otherwise>
          <!-- do nothing -->XXXXX
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <!-- /JS -->
  </xsl:template>

  <xsl:template match="demo | guided | exercise | workbook">
    <xsl:call-template name="insertAssignmentNumberButton"/>

    <xsl:call-template name="insertPageTitleFromParameter">
      <xsl:with-param name="actualText" select="name()" />
    </xsl:call-template>
    <xsl:call-template name="insertClassNameAsLabelPlusContents"/>
  </xsl:template>


  <xsl:template match="assignment-name">
    <!-- Do nothing, assignment-name is inserted in main loop ahead of text -->
  </xsl:template>

  <!-- teachernotes and additional instruction can go before or after the slide -->
  <!-- slides are misc, termdefinition, exercise, guided, demo -->
  <!-- -->
  <xsl:template match="teachernote | el_additional_instruction">
    <xsl:call-template name="insertClassNameAsLabel"/>
  </xsl:template>

  <xsl:template match="description">
    <div class="exampleDescriptionLabel">Example:</div>
    <div class="exampleDescription">
       <xsl:copy-of select="@*"/>
       <xsl:value-of select="." disable-output-escaping="yes" />
    </div>
  </xsl:template>

  <xsl:template match="img">
    <div class="slide" data-content="slide">
      <img width="100%">
        <xsl:attribute name="src">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </img>
    </div>
  </xsl:template>

  <!--<xsl:template match="activity_image">
    <img>
      <xsl:attribute name="src">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </img>
  </xsl:template>-->

  <!-- nextLine used in slides to create breaks where needed -->
  <xsl:template match="nextline">
    <div class="nextLine">
      <xsl:apply-templates/>
    </div>
  </xsl:template>  
  
  <xsl:template match="math">
    <math>
      <xsl:apply-templates/>
    </math>
  </xsl:template>
  <xsl:template match="mfrac">
    <mfrac>
      <xsl:apply-templates/>
    </mfrac>
  </xsl:template>
  <xsl:template match="mn">
    <mn>
      <xsl:apply-templates/>
    </mn>
  </xsl:template>
  <xsl:template match="mo">
    <mo>
      <xsl:apply-templates/>
    </mo>
  </xsl:template>
  <xsl:template match="mi">
    <mi>
      <xsl:apply-templates/>
    </mi>
  </xsl:template>
  <xsl:template match="mrow">
    <mrow>
      <xsl:apply-templates/>
    </mrow>
  </xsl:template>
  <!-- table/td/tr used in slides to create breaks where needed -->
 <xsl:template match="table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="tr">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="td">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>



  <xsl:template match="answer">
    <div class="answerLabel">Answer:</div>
    <div class="answer">
       <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Do Nothing with these tags, they have been taken care of elsewhere but not matched yet -->

  <xsl:template match="forced-slide-image-title | forced-slide-instruction-title">
    <xsl:call-template name="insertPageTitleFromParameter">
      <xsl:with-param name="actualText" select="." />
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>


