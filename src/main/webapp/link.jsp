<%@ page import="blackboard.data.user.User,
                 blackboard.platform.security.Entitlement,
                 blackboard.platform.security.SecurityUtil" %>
<%@ taglib uri="/bbNG" prefix="bbNG" %>


<bbNG:genericPage ctxId="ctx" title="Impersonate">

    <bbNG:pageHeader>
        <bbNG:pageTitleBar title="Impersonate"/>
    </bbNG:pageHeader>

    <bbNG:breadcrumbBar environment="SYS_ADMIN" navItem="admin_plugin_manage">
        <bbNG:breadcrumb>Impersonate</bbNG:breadcrumb>
    </bbNG:breadcrumbBar>

    <%
        final User user = ctx.getUser();

        if (!SecurityUtil.userHasEntitlement(new Entitlement("boc.impersonate.admin.le.EXECUTE")) &&
                !SecurityUtil.userHasEntitlement(new Entitlement("boc.impersonate.admin.all.EXECUTE"))) {
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
