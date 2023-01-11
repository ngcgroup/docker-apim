package org.bhn.apim.handler;

import java.util.Map;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.synapse.MessageContext;
import org.apache.synapse.core.axis2.Axis2MessageContext;
import org.wso2.carbon.apimgt.gateway.handlers.security.APISecurityException;


public class CustomTokenExtractHandler extends AbstractHandler {
    private static final Log log = LogFactory.getLog(CustomTokenExtractHandler.class);

    public boolean handleRequest(MessageContext messageContext) {
        try {
            if (extractHeaders(messageContext)) {
                return true;
            }
        } catch (APISecurityException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean handleResponse(MessageContext messageContext) {
        return true;
    }

    public boolean extractHeaders(MessageContext synCtx) throws APISecurityException {
        Map transportHeaders = getTransportHeaders(synCtx);
        final String authorization = (String) transportHeaders.get("authorization");
        log.info("Custom token extract handler."+ authorization);
        transportHeaders.put("X-Test-sample", "We are here");


        return true;
    }

    private Map getTransportHeaders(MessageContext messageContext) {
        return (Map) ((Axis2MessageContext) messageContext).getAxis2MessageContext().
                getProperty(org.apache.axis2.context.MessageContext.TRANSPORT_HEADERS);
    }
}
