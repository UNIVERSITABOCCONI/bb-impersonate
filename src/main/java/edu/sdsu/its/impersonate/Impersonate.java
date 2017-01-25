package edu.sdsu.its.impersonate;


import blackboard.data.user.User;
import blackboard.data.user.User.SystemRole;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class Impersonate {
    BbPersistenceManager bbPm;
    Id userId;
    User user;
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
        user = userLoader.loadByUserName(targetId);
        userId = user.getId();


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

    public boolean checkAuth(Context ctx) {
        if (ctx.getUser().getSystemRole().getEntitlements().has(new Entitlement("sdsu.impersonate.admin.EXECUTE"))) {
            // Permitted

            //noinspection RedundantIfStatement
            if (ctx.getUser().getSystemRole().compareTo(user.getSystemRole()) >= 0)
                // Trying to impersonate a user less or equal system authority
                return true;

            return false;
        }
        return false;

    }
}