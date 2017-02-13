<%@ page import="blackboard.persist.PersistenceException,
                 blackboard.platform.security.SecurityUtil,
                 blackboard.platform.security.authentication.BbAuthenticationFailedException,
                 edu.sdsu.its.impersonate.Impersonate,
                 org.apache.log4j.Logger" %>
<%@ taglib uri="/bbData" prefix="bbData" %>
<%@ taglib uri="/bbNG" prefix="bbNG" %>
<%


%>

<bbData:context id="ctx">
	<bbNG:breadcrumbBar navItem="admin_plugin_manage">
		<bbNG:breadcrumb>Impersonate</bbNG:breadcrumb>
	</bbNG:breadcrumbBar>

	<bbNG:genericPage ctxId="ctx" title="Impersonate">


		<bbNG:pageHeader>
			<bbNG:pageTitleBar title="Impersonate"/>
		</bbNG:pageHeader>

		<%
			final Logger logger = Logger.getLogger(this.getClass());
			String netid = request.getParameter("netid");
			Impersonate imp = null;

			try {
				imp = new Impersonate(netid, request, response);
				logger.debug(String.format("\"%s\" is requesting to Impersonate \"%s\"", ctx.getUser().getUserName(), netid));

				if (SecurityUtil.userHasEntitlement("sdsu.impersonate.admin.all.EXECUTE") || (
						SecurityUtil.userHasEntitlement("sdsu.impersonate.admin.greater.EXECUTE") &&
								imp.checkRelation(ctx)
				)) {
					logger.info("User " + ctx.getUser().getUserName() + " is now impersonating user " + netid + ". Bon voyage!");
					imp.doImpersonate();
				}

				response.sendRedirect(request.getScheme() + "://" + request.getServerName() + "/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_1_1");

			} catch (BbAuthenticationFailedException e) {
				logger.warn("Authentication Failure, insufficient permissions", e);
			} catch (PersistenceException pe) {
				logger.warn("User not found.", pe);
			}
		%>

		<bbNG:okButton/>

	</bbNG:genericPage>
</bbData:context>