<cftry>
    <cfparam name="book" default="" />
    <cfparam name="qTerm" default="" />

    <cfset addEditFunctions = createObject("addedit") />
    <cfset addEditFunctions.processForms(form)>
    
    <div class="row">
        <div id="main" class="col-9">
            <cfif book neq "">
                <cfoutput>#mainForm()#</cfoutput>
            </cfif>
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
    
        <cfset thisbookDetails = addEditFunctions.bookDetails( book ) />
        <cfset allPublishers = addEditFunctions.allPublishers() />
        <cfset allGenres = addEditFunctions.allGenres() />
        <cfset allGenresForThisBook = addEditFunctions.bookGenres( book ) />

        <cfoutput>
            <form action="#cgi.script_name#?tool=addedit&qTerm=#qterm#" method="POST"enctype="multipart/form-data" >                
                <div class="form-floating mb-3">
                    <input type="text" id="isbn13" name="isbn13" value="#thisbookDetails.isbn13[1]#" placeholder="Enter the ISBN13" class="form-control"/>                
                    <label for="isbn13">ISBN13:</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" id="isbn" name="isbn" value="#thisbookDetails.isbn[1]#" placeholder="Enter the ISBN" class="form-control"/>
                    <label for="isbn">ISBN:</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" id="title" name="title" value="#thisbookDetails.title[1]#" placeholder="Book Title" class="form-control"/>
                    <label for="title">Book Title</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="weight" name="weight" value="#thisbookDetails.weight[1]#" placeholder="Enter the Book Weight" class="form-control"/>
                    <label for="weight">Book Weight</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="year" name="year" value="#thisbookDetails.year[1]#" placeholder="Enter the Year Published" class="form-control"/>
                    <label for="year">Year Published</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="number" id="pages" name="pages" value="#thisbookDetails.pages[1]#" placeholder="Enter the Amount of Pages" class="form-control"/>
                    <label for="pages">Amount of Pages</label>
                </div>
                <div class="form-floating mb-3">
                    <select class="form-select" id="publisher" name="publisher" aria-label="Publisher Select Control">
                        <option value=""></option>
                        <cfloop query="allPublishers">
                            <option value="#publisher#"  #publisher eq thisbookDetails.publisherid ? "selected" : ""#> #name# </option>
                        </cfloop>
                    </select>
                    <label for="publisherid">Publisher</label>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="uploadimage">Upload Cover</label>
                        <div class="input-group mb-3">
                            <input type="file" id="uploadImage" name="uploadimage" class="form-control" />
                            <input type="hidden" name="image" value="#trim(thisBookDetails.image[1])#" />
                        </div>
                    </div>
                    <div class="col">
                        <cfif thisBookDetails.image[1].len() gt 0>
                            <img src="../images/#trim(thisBookDetails.image[1])#" style="width:200px" />
                        </cfif>
                    </div>
                </div>
                <div class="form-floating mb-3">
                    <div>
                        <label for="description">Description</label>
                    </div>
                    <textarea id="description" name="description">
                        <cfoutput>#thisBookDetails.description#</cfoutput>
                    </textarea>
                    <script>
                        ClassicEditor
                            .create(document.querySelector('##description'))
                            .catch(error => {console.dir(error)});
                    </script>
                 </div>
                 <div>
                    <h4>Genres</h4>
                    <cfloop query="allGenres">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="#id#" id="genre#id#" name="genre">
                            <label class="form-check-label" for="genre#id#">
                                #name#
                            </label>
                        </div>
                    </cfloop>
                    <cfloop query="bookGenres">
                        <script type="text/javascript">
                            document.getElementById("genre#genreId#").checked=true;
                        </script>
                    </cfloop>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%">Add Book</button>
            </form>

        </cfoutput>
    </cfif>
</cffunction>

<cffunction name="sideNav">
    <cfset allBooks = addEditFunctions.sideNavBooks( qTerm ) />
    <div>
        Book List - Found by Wizards, Scary Right?
    </div>
    <cfoutput>
        #findBookForm()#
        <ul class="nav flex-column">
            <li class ="nav-item">
                <a class="nav-link" href="#cgi.SCRIPT_NAME#?tool=addedit&book=new"> Add a New Book </a>
            </li>
            <cfif qTerm.len()==0>
                No Search Term Entered
            <cfelseif allBooks.recordcount==0>
                No Results Found
            <cfelse>
                <cfloop query="allBooks">
                    <li class="nav-item">
                        <a class="nav-link" href="#cgi.SCRIPT_NAME#?tool=addedit&book=#isbn13#&qTerm=#qTerm#"> #trim(title)#</a>
                    <li>
                </cfloop>
            </cfif>
        </ul>
    </cfoutput>
</cffunction>

<cffunction name="findBookForm">
    <cfoutput>
        <form action="#cgi.script_name#?tool=#tool#" method="post">
            <div class="form-floating mb-3">
                <input type="text" id="qterm" name="qterm" class="form-control" value="#qterm#" placeholder="Enter a search term to find a book to edit" />
                <label for="qterm">Search Inventory </label>
            </div>
        </form>
    </cfoutput>
</cffunction>
   