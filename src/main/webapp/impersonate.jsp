<%@ page import="blackboard.persist.PersistenceException,
                 blackboard.platform.security.SecurityUtil,
                 blackboard.platform.security.authentication.BbAuthenticationFailedException,
                 edu.sdsu.its.impersonate.Impersonate,
                 org.apache.log4j.Logger" %>
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
            final Logger LOGGER = Logger.getLogger(this.getClass());
            String netid = request.getParameter("netid");
            Impersonate imp = null;

            try {
                imp = new Impersonate(netid, request, response);
                final String requesterUsername = ctx.getUser().getUserName();

                LOGGER.debug(String.format("\"%s\" is requesting to Impersonate \"%s\"", requesterUsername, netid));

                if (SecurityUtil.userHasEntitlement("sdsu.impersonate.admin.all.EXECUTE")) {
                    LOGGER.debug("Requesting User has permissions to impersonate ALL Users");

                    imp.doImpersonate();
                    LOGGER.warn(String.format("\"%s\" is now impersonating \"%s\"!", requesterUsername, netid));
                } else if (SecurityUtil.userHasEntitlement("sdsu.impersonate.admin.le.EXECUTE") &&
                        imp.checkRelation(ctx)) {
                    LOGGER.debug("Requesting User has permissions to impersonate LESS/EQUAL Users");

                    imp.doImpersonate();
                    LOGGER.warn(String.format("\"%s\" is now impersonating \"%s\"!", requesterUsername, netid));
                }

                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + "/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_1_1");

            } catch (BbAuthenticationFailedException e) {
                LOGGER.error("Authentication Failure, insufficient permissions", e);
            } catch (PersistenceException pe) {
                LOGGER.warn(String.format("User \"%s\" not found", netid));
            }
        %>

        <bbNG:okButton/>

    </bbNG:genericPage>
</bbData:context>