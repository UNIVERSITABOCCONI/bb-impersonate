<%@ page import="blackboard.persist.PersistenceException,
                 blackboard.platform.security.SecurityUtil,
                 blackboard.platform.security.authentication.BbAuthenticationFailedException,
                 boc.impersonate.Impersonate" %>
<%@ taglib uri="/bbData" prefix="bbData" %>
<%@ taglib uri="/bbNG" prefix="bbNG" %>

<bbData:context id="ctx">
    <bbNG:breadcrumbBar navItem="admin_plugin_manage">
        <bbNG:breadcrumb>Impersonate</bbNG:breadcrumb>
    </bbNG:breadcrumbBar>

    <bbNG:genericPage ctxId="ctx" title="Impersonate">


        <bbNG:pageHeader>
            <bbNG:pageTitleBar title="Impersonate"/>
        </bbNG:pageHeader>

        <%
            String netid = request.getParameter("netid");
            Impersonate imp = null;

            try {
                imp = new Impersonate(netid, request, response);
                final String requesterUsername = ctx.getUser().getUserName();

                if (SecurityUtil.userHasEntitlement("boc.impersonate.admin.all.EXECUTE")) {

                    imp.doImpersonate();
                } else if (SecurityUtil.userHasEntitlement("boc.impersonate.admin.le.EXECUTE") &&
                        imp.checkRelation(ctx)) {

                    imp.doImpersonate();
                }

                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + "/");

            } catch (BbAuthenticationFailedException e) {
            } catch (PersistenceException pe) {
            }
        %>

        <bbNG:okButton/>

    </bbNG:genericPage>
</bbData:context>