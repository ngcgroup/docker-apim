package com.bhn.apim;

import org.osgi.service.component.annotations.Component;
import org.wso2.carbon.apimgt.common.gateway.dto.JWTInfoDto;
import org.wso2.carbon.apimgt.common.gateway.jwtgenerator.APIMgtGatewayJWTGeneratorImpl;
import org.wso2.carbon.apimgt.common.gateway.jwtgenerator.AbstractAPIMgtGatewayJWTGenerator;

import java.util.Map;
import java.util.UUID;

/**
 * @author jrube00 Created 1/7/23
 */
@Component(
    enabled = true,
    service = AbstractAPIMgtGatewayJWTGenerator.class,
    name = "customgatewayJWTGenerator"
)
public class CustomGatewayJWTGenerator extends APIMgtGatewayJWTGeneratorImpl {

  @Override
  public Map<String, Object> populateStandardClaims(JWTInfoDto jwtInfoDto) {
    return super.populateStandardClaims(jwtInfoDto);
  }

  @Override
  public Map<String, Object> populateCustomClaims(JWTInfoDto jwtInfoDto) {

    Map<String, Object> claims = super.populateCustomClaims(jwtInfoDto);
    claims.put("uuid", UUID.randomUUID().toString());
    return claims;
  }
}