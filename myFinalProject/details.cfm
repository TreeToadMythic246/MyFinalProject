<cfparam name="searchme" default="" />
<cfparam name="genre" default="" />


<cfoutput>
    <cfset bookInfo=bookstoreFunctions.obtainSearchResults( searchme, genre ) />

    <cfif bookInfo.recordcount == 0>
        #noResults()#
    <cfelseif bookinfo.recordcount == 1>
        #oneResult()#
    <cfelse>
        #manyResults()#
    </cfif>

</cfoutput>

<cffunction name="noResults">
    There were no results to be found. Please try again.
</cffunction>

<cffunction name = "oneResult">
    <cfoutput>
        <h2>Search Results</h2>
        <div class="row">
            <div class="col-6"> 
                <img src="images/#bookinfo.image[1]#" style="width:300px"/>
            </div>
            <div class="col-6">
                Title: #bookInfo.title[1]#</br>
                Year: #bookInfo.year[1]#</br>
                Pages: #bookInfo.pages[1]#</br>
                Language: #bookInfo.language[1]#</br>
                Publisher: #bookInfo.name[1]#</br>
                Description: #bookInfo.description[1]#</br>
            </div>
        </div>
    </cfoutput>
</cffunction>

<cffunction name="manyResults">
    <cfoutput>
        <div>
            <h3>
                <cfoutput>
                    #bookstoreFunctions.resultsHeader(searchme, genre)#
                </cfoutput>
            </h3>
        </div>
        <div> I found #bookinfo.recordcount# books in relation to that search. </div>
            <div>
                <ol class="nav flex-column">
                    <cfloop query="bookInfo">
                        <li class="nav-item">
                            <a class="nav-link" href="#cgi.SCRIPT_NAME#?p=details&searchme=#(isbn13)#">
                                #trim(title)#
                            </a>
                        </li>
                    </cfloop>
                </ol>
            </div>
        </div>
        <div>
        Here are the results to choose from.
        </div>
    </cfoutput>
</cffunction>