<cftry>
    <cfparam name="content" default="">
    <cfparam name="qTerm" default=""> 

    <cfset addEditFunctions = createObject("managecontent") />
    <cfset addEditFunctions.processForms(form) >

    <div class="row">
        <div id="main" class="col-9">
            <cfif content.len() gt 0 >  
                <cfoutput>#mainContentForm()#</cfoutput>
            </cfif>
        </div>

        <div id="leftgutter" class="col-lg-3 order-first">
            <cfoutput>#sideContentNav()#</cfoutput>
        </div>
    </div>
    <cfcatch type="any">
        <cfoutput>
            #cfcatch#
        </cfoutput>
    </cfcatch>
</cftry>

<cffunction name="mainContentForm">
    <cfset var thisContentDetails = addEditFunctions.contentDetails(content) />
    <cfset var allContents = addEditFunctions.allContents() />
    <cfset var allContentsForContent = addEditFunctions.contentContents(content) />

    <cfoutput>
        <h3>Edit Content</h3>
        <form action="#cgi.script_name#?tool=managecontent&content=#content#&qterm=#qterm#" method="POST" enctype="multipart/form-data">
            <div class="form-floating mb-3">
                <label for="contentid">New UUID</label>
                <input type="text" id="contentid" name="contentid" value="#thisContentDetails.contentid[1]#" placeholder="Enter New UUID" class="form-control">
                
            </div>
            <div class="form-floating mb-3">
                <label for="title">Content Article Title</label>
                <input type="text" id="title" name="title" value="#thisContentDetails.title[1]#" placeholder="Enter Article Title" class="form-control">
                
            </div>
            <div class="form-floating mb-3">
                <label for="description">Content Description Editor</label>
                <textarea id="description" name="description">#thisContentDetails.description[1]#</textarea>
                <!-- Implement WYSIWYG editor here -->
                <script src="https://cdn.ckeditor.com/ckeditor5/37.0.1/classic/ckeditor.js"></script>
                <script>
                    ClassicEditor
                    .create(document.querySelector('##description'))
                    .catch(error => {console.dir(error)});
                </script>
            </div>

            <div>
                <h3>Content Titles</h3>
                <cfloop query="allContents">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="#contentid#" id="content#contentid#" name="contentid">
                        <label class="form-check-label" for="content#contentid#">#title#</label>
                    </div>  
                </cfloop>
                <cfloop query="allContentsForContent">
                    <script type="text/javascript">
                        document.getElementById("content#id#").checked = true;
                    </script>
                </cfloop>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%">Update Content</button>
        </form>
    </cfoutput>
</cffunction>

<cffunction name="sideContentNav">
    <cfset var allContents = addEditFunctions.sideContentNav(qTerm) >    
    
    <cfoutput>
        #findContentForm()#
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="#cgi.script_name#?tool=managecontent&content=new">Click Here to Enter A New Content Article</a>
                <hr>
            </li>
            <cfif qTerm.len() == 0>
                <!-- No Search Term Entered -->
            <cfelseif allContents.recordcount == 0>
                No Results Found
            <cfelse>
                <cfloop query="allContents">
                    <li class="nav-item">
                        <a class="nav-link" href="#cgi.script_name#?tool=managecontent&content=#contentid#&qTerm=#qTerm#">#trim(title)#</a>
                    </li>
                </cfloop>
            </cfif>
        </ul>
    </cfoutput>
</cffunction>

<cffunction name="findContentForm">
    <cfoutput>
        <br>
        <h5>Available Content for Editing:</h5>
        <form action="#cgi.script_name#?tool=managementcontent&content=#content#" method="post">
            <div class="form-floating mb-3">
                <input type="text" id="qterm" name="qterm" class="form-control" value="#qterm#" placeholder="Enter a search term to find content to edit">
                <label for="qterm">Search Available Content to Edit</label>
            </div>
        </form>
    </cfoutput>
</cffunction>
