<cftry>
    <cfparam name="book" default="" />
    <cfparam name="qTerm" default="" />

    <cfset addEditFunctions = createObject("addedit") />
    <cfset addEditFunctions.processForms(form)>
    
    <div class="row">
        <div id="main" class="col-9">
            <cfoutput>#mainForm()#</cfoutput>
        </div>

        <div id="leftgutter" class="col-lg-3 order-first">
            <cfoutput>#sideNav()#</cfoutput>
        </div>
    </div>
    <cfcatch type="any">
        <cfoutput>
            #cfcatch#
        </cfoutput>
    </cfcatch>
</cftry>

<cffunction name="mainForm">

    <cfif book.len() == 0>
        Please choose a book from the left hand side.
    <cfelse>

        <cfset allPublishers = addEditFunctions.allPublishers() />
        <cfset bookDetails = addEditFunctions.bookDetails( book ) />

        <cfoutput>
            <form action="#cgi.script_name#?tool=addedit" method="post">
                <div class="form-floating mb-3">
                    <input type="text" id="isbn13" name="isbn13" value="#bookDetails.isbn13[1]#" placeholder="Enter the ISBN13" class="form-control"/>                
                    <label for="isbn13">ISBN13:</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" id="isbn" name="isbn" value="#bookDetails.isbn[1]#" placeholder="Enter the ISBN" class="form-control"/>
                    <label for="isbn">ISBN:</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" id="title" name="title" value="#bookDetails.title[1]#" placeholder="Book Title" class="form-control"/>
                    <label for="title">Book Title</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="weight" name="weight" value="#bookDetails.weight[1]#" placeholder="Enter the Book Weight" class="form-control"/>
                    <label for="weight">Book Weight</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="year" name="year" value="#bookDetails.year[1]#" placeholder="Enter the Year Published" class="form-control"/>
                    <label for="year">Year Published</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="pages" name="pages" value="#bookDetails.pages[1]#" placeholder="Enter the Amount of Pages" class="form-control"/>
                    <label for="pages">Amount of Pages</label>
                </div>
                <div class="form-floating mb-3">
                    <select id="publisher" name= "publisher" class="form-control"/>
                        <option value=""></option>
                        <cfloop query="allPublishers">
                            <option value="#id#"  #bookDetails.publisherId[1] == id ? "selected" : ""#     > #name# </option>
                        </cfloop>

                    </select>
                    <label for="publisher">Publisher</label>
                </div>
                <button type="submit" class="btn btn-primary">Add Book</button>
            </form>
        </cfoutput>
    </cfif>
</cffunction>

<cffunction name="sideNav">
    <cfset allBooks = addEditFunctions.sideNavBooks()>
    <div>
        Book List
    </div>

    <cfoutput>
        <ul class="nav flex-column">
            <li class ="nav-item">
                <a href="#cgi.SCRIPT_NAME#?tool=addedit&book=new" class="nav-link">
                    New Book
                </a>
            </li>
        <cfloop query="allBooks">
            <li class ="nav-item">
                <a href="#cgi.SCRIPT_NAME#?tool=addedit&book=#isbn13#" class="nav-link">#trim(title)#</a>
            </li>
        </cfloop>        
        </ul>
    </cfoutput>
</cffunction>
