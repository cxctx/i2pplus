<%
/*
 * USE CAUTION WHEN EDITING
 * Trailing whitespace OR NEWLINE on the last line will cause
 * IllegalStateExceptions !!!
 */

    // Redirect from /tunnelsparticipating to /transit
    response.setStatus(301);
    response.setHeader("Cache-Control","immutable");
    response.setHeader("Location","/webmail");
    // force commitment
    response.getOutputStream().close();
%>