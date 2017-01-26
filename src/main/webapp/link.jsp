<%@ page import="blackboard.platform.security.Entitlement,
                 edu.sdsu.its.impersonate.Impersonate" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="blackboard.data.user.User" %>
<%@ page import="blackboard.platform.security.SecurityUtil" %>
<%@ taglib uri="/bbNG" prefix="bbNG" %>


<bbNG:genericPage ctxId="ctx" title="Impersonate">

    <bbNG:pageHeader>
        <bbNG:pageTitleBar title="Impersonate"/>
    </bbNG:pageHeader>

    <bbNG:breadcrumbBar environment="SYS_ADMIN" navItem="admin_plugin_manage">
        <bbNG:breadcrumb>Impersonate</bbNG:breadcrumb>
    </bbNG:breadcrumbBar>

    <%
        final Logger logger = Logger.getLogger(this.getClass());
        final User user = ctx.getUser();

//        Impersonate imp = new Impersonate(user.getUserName(), request, response);
        logger.debug(String.format("\"%s\" is requesting to Impersonate a user...", user.getUserName()));

        if (!SecurityUtil.userHasEntitlement(new Entitlement("sdsu.impersonate.admin.EXECUTE"))) {
            logger.warn("Insufficient Permissions to Impersonate for User: " + user.getUserName());
            response.sendError(403, "You do not have sufficient privileges to complete the requested action.");
            return;
        }

    %>

    <form name="config" method="post" action="impersonate.jsp">
        <bbNG:dataCollection>
            <bbNG:step title="Impersonate">

                <bbNG:dataElement label="Username" labelFor="Username">
                    <input type="text" name="netid" size="25"/>
                </bbNG:dataElement>

            </bbNG:step>
            <bbNG:stepSubmit/>
        </bbNG:dataCollection>
    </form>

</bbNG:genericPage>
