local host(name, username, address, secretName, secretKey, username) = {
  apiVersion: 'postgres.letsbuild.com/v1alpha1',
  kind: 'Host',
  metadata: {
    name: name,
  },
  spec: {
    address: address,
    username: username,
    secretRef: {
      name: secretName,
      key: secretKey,
    },
  },
};

local database(databaseName, hostName, dropOnDeletion=true, name='', extensions=[]) = {
  local defaultName = '%(host)s-%(database)s' % {
    host: hostName,
    database: databaseName,
  },

  apiVersion: 'postgres.letsbuild.com/v1alpha1',
  kind: 'Database',
  metadata: {
    name: if name == '' then defaultName else name,
    annotations: {
      'argocd.argoproj.io/sync-wave': '-3',
    },
  },
  spec: {
    databaseName: databaseName,
    dropOnDeletion: dropOnDeletion,
    [if extensions != [] then 'extensions']: extensions,
    hostRef: {
      name: hostName,
    },
  },
};

local user(username, hostName, databaseName, priv, secretName='', name='') = {

  local defaultName = '%(host)s-%(database)s-%(user)s' % {
    host: hostName,
    database: databaseName,
    user: username,
  },

  apiVersion: 'postgres.letsbuild.com/v1alpha1',
  kind: 'User',
  metadata: {
    name: if name == '' then defaultName else name,
    annotations: {
      'argocd.argoproj.io/sync-wave': '-2',
    },
  },
  spec: {
    hostRef: {
      name: hostName,
    },
    username: username,
    secretName: if secretName == '' then defaultName else secretName,
    grant: {
      databaseName: databaseName,
      priv: priv,
    },
  },
};

{
  host:: host,
  database:: database,
  user:: user,
}
