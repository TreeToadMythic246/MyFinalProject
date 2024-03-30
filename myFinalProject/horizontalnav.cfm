<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">
        <img src="images/rab.png" alt="Read Anthony's Books Logo" width = "100" height = "100" />
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto" style="margin-top: 10px;">
            <li class="nav-item active">
                <a href="index.cfm">Home </a>
                &nbsp;&nbsp;&nbsp;&nbsp; 
            </li>
            <li class="nav-item">
                <a href="management1.cfm">Management </a> 
                &nbsp;&nbsp;&nbsp;&nbsp; 
            </li>
            <li class="nav-item">
                <a href="management2.cfm">Content</a>
                &nbsp;&nbsp;&nbsp;&nbsp; 
            </li>
            <li class="nav-item">
                <a href="storeinformation.cfm">About</a>
            </li>
        </ul>
        <cfoutput>
            &nbsp;&nbsp;&nbsp;&nbsp; 
            <form class="d-flex" action="#cgi.SCRIPT_NAME#?p=details" method="POST">
                <input class="form-control me-2" type="search" name="searchme" placeholder="Search"aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Search</button>
            </form>

            <ul class="navbar-nav mr-auto">
            <cfif session.user.isLoggedIn>
                <li class="nav-item">
                    <span class="nav-link">Welcome #session.user.firstname# #session.user.lastname#</span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#cgi.SCRIPT_NAME#?p=logoff ">Logout</a>
                </li>
            <cfelse>
                <li class="nav-item">
                    <a class="nav-link" href="#cgi.SCRIPT_NAME#?p=login">Login</a>
                </li>
            </cfif>
            </ul>
        </cfoutput>

    </div>
</nav>
