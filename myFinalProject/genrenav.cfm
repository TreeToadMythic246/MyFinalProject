<cfset genresInStock = bookstoreFunctions.genresInStock() />

<h3>Search By Genre</h3>
            <ul class="nav flex-column">
               <cfoutput query="genresInStock">
                <li class="nav-item">
                    <a class="nav-link" href="#cgi.SCRIPT_NAME#?p=details&genre=#genreid#">#name#</a>
                </li>
                </cfoutput>
            </ul>

            <!--------
                 <li class="nav-item"><a class="nav-link">Childrens's Books</a></li>
                <li class="nav-item"><a class="nav-link">Mysteries</a></li>
                <li class="nav-item"><a class="nav-link">Non-Fiction</a></li>
                <li class="nav-item"><a class="nav-link">Self Help</a></li>
                <li class="nav-item"><a class="nav-link">Philosophy</a></li>
                <li class="nav-item"><a class="nav-link">Religion</a></li>
                <li class="nav-item"><a class="nav-link">Technology</a></li>
            --------->
