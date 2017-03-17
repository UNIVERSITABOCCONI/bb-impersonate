package edu.sdsu.its.impersonate;


import blackboard.data.user.User;
import blackboard.persist.BbPersistenceManager;
import blackboard.persist.Id;
import blackboard.persist.KeyNotFoundException;
import blackboard.persist.PersistenceException;
import blackboard.persist.user.UserDbLoader;
import blackboard.platform.context.Context;
import blackboard.platform.context.ContextManager;
import blackboard.platform.context.ContextManagerFactory;
import blackboard.platform.security.Entitlement;
import blackboard.platform.security.authentication.BbAuthenticationFailedException;
import blackboard.platform.security.authentication.BbSecurityException;
import blackboard.platform.security.authentication.SessionStub;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Iterator;


public class Impersonate {
    private static final Logger LOGGER = Logger.getLogger(Impersonate.class);

    BbPersistenceManager bbPm;
    Id userId;
    User user;
    User impersonatedUser;
    HttpServletRequest impRequest;
    HttpServletResponse impResponse;
    String username;
    private ContextManager contextManager;

    public Impersonate(String targetId, HttpServletRequest request, HttpServletResponse response) throws KeyNotFoundException, PersistenceException {
        impRequest = request;
        impResponse = response;
        contextManager = ContextManagerFactory.getInstance();
        username = targetId;


        UserDbLoader userLoader = UserDbLoader.Default.getInstance();
        impersonatedUser = userLoader.loadByUserName(targetId);
        userId = impersonatedUser.getId();
    }


    public void doImpersonate() throws BbAuthenticationFailedException {

        SessionStub sessionStub;

        try {
            sessionStub = new SessionStub(impRequest);
            sessionStub.associateSessionWithUser(username);
        } catch (BbSecurityException e) {
            e.printStackTrace();
        }

        contextManager.purgeContext();
        contextManager.setContext(impRequest);
    }

    public boolean checkRelation(Context ctx) {
        User contextUser = ctx.getUser();
        LOGGER.debug("Executing User Role: " + contextUser.getSystemRole().getDisplayName());
        LOGGER.debug("Requested Role: " + impersonatedUser.getSystemRole().getDisplayName());

        final Iterator<Entitlement> contextUserRoleIter = contextUser.getSystemRole().getEntitlements().iterator();
        int contextUserRoleEntitlementCount = 0;
        while (contextUserRoleIter.hasNext()) contextUserRoleEntitlementCount++;

        final Iterator<Entitlement> imperUserRoleIter = contextUser.getSystemRole().getEntitlements().iterator();
        int imperUserRoleEntitlementCount = 0;
        while (imperUserRoleIter.hasNext()) imperUserRoleEntitlementCount++;

        LOGGER.debug(String.format("Executing User Role has %d entitlements", contextUserRoleEntitlementCount));
        LOGGER.debug(String.format("Requested Role has  %d entitlements", imperUserRoleEntitlementCount));

        if (contextUserRoleEntitlementCount >= imperUserRoleEntitlementCount) {
            // Trying to impersonate a user less or equal system authority
            LOGGER.info("Impersonate User Level Check Passed");
            return true;
        }

        LOGGER.warn("Impersonate User Level Check FAILED");
        return false;
    }
}