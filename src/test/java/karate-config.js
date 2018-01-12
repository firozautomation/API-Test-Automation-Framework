function() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
	someUrlBase: 'http://ver-01-shared-services-service-request-service.ver.cloud.ds.gehc.net/serviceRequest/v1/serviceRequests/'
  }
  if (env == 'ver') {
    config.someUrlBase = 'http://ver-01-shared-services-service-request-service.ver.cloud.ds.gehc.net/serviceRequest/v1/serviceRequests';
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}

function () {
  return { baseUrl: 'http://ver-02-shared-services-service-request-service.ver.cloud.ds.gehc.net/serviceRequest/v1/' };
}

function() {
  return { tokenURL: 'https://location.ver02.geicenter.com' };
}
