<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@include file="css.jsi" %>
<%@include file="csp-unsafe.jsi" %>
<%=intl.title("graphs")%>
 <jsp:useBean class="net.i2p.router.web.helpers.GraphHelper" id="graphHelper" scope="request" />
 <jsp:setProperty name="graphHelper" property="contextId" value="<%=i2pcontextId%>" />
<% /* GraphHelper sets the defaults in setContextId, so setting the properties must be after the context */ %>
 <jsp:setProperty name="graphHelper" property="*" />
<%
    graphHelper.storeWriter(out);
    graphHelper.storeMethod(request.getMethod());
    // meta must be inside the head
    boolean allowRefresh = intl.allowIFrame(request.getHeader("User-Agent"));
    if (allowRefresh) {
        out.print(graphHelper.getRefreshMeta());
    }
%>
</head>
<body id="perfgraphs">
<script nonce="<%=cspNonce%>" type="text/javascript">progressx.show();</script>
<%@include file="summary.jsi" %>
<%
    // needs to be after the summary bar is rendered, so
    // that the restart button is processed
    String stat = request.getParameter("stat");
    if (stat == null) {
        // probably because restart or shutdown was clicked
        response.setStatus(307);
        response.setHeader("Location", "/graphs");
        // force commitment
        response.getWriter().close();
        return;
    }
%>
<h1 class="perf"><%=intl._t("Performance Graph")%></h1>
<div class="main" id="graph_single">
 <jsp:getProperty name="graphHelper" property="singleStat" />
</div>
<script nonce="<%=cspNonce%>" type="text/javascript">
  var main = document.getElementById("perfgraphs");
  var graph = document.getElementById("single");
  var graphImage = document.getElementById("graphSingle");
  function injectCss() {
    graph.addEventListener("load", function() {
      var graphWidth = graphImage.naturalWidth;
      var graphHeight = graphImage.height;
      var sheet = window.document.styleSheets[0];
<%
    if (graphHelper.getGraphHiDpi()) {
%>
    sheet.insertRule(".graphContainer#hidpi {width: " + ((graphWidth / 2) + 8) + "px; height: " + ((graphHeight / 2) + 8) + "px;}", sheet.cssRules.length);
<%
    } else {
%>
    sheet.insertRule(".graphContainer {width: " + (graphWidth + 4) + "px; height: " + (graphHeight + 4) + "px;}", sheet.cssRules.length);
<%
    }
%>
    });
  }
  function initCss() {
    if (graphImage != null || graphWidth != graphImage.naturalWidth || graphHeight != graphImage.height) {
      graph.addEventListener("load", injectCss());
    } else {
      location.reload(true);
    }
  }
  initCss();
<%
    if (graphHelper.getRefreshValue() > 0) {
%>
if (graph) {
  setInterval(function() {
    progressx.show();
    var graphURL = window.location.href + "&" + new Date().getTime();
    var xhrgraph = new XMLHttpRequest();
    xhrgraph.open('GET', graphURL, true);
    xhrgraph.responseType = "document";
    xhrgraph.onreadystatechange = function () {
      if (xhrgraph.readyState==4 && xhrgraph.status==200) {
        var graphResponse = xhrgraph.responseXML.getElementById("single");
        var graphParent = graph.parentNode;
        graphParent.replaceChild(graphResponse, graph);
      }
    }
    window.addEventListener("pageshow", progressx.hide());
    graph.addEventListener("load", injectCss());
    xhrgraph.send();
  }, <% out.print(graphHelper.getRefreshValue() * 1000); %>);
}
<%  } %>
</script>
<%@include file="summaryajax.jsi" %>
<script nonce="<%=cspNonce%>" type="text/javascript">window.addEventListener("pageshow", progressx.hide());</script>
</body>
</html>
