local serviceMonitor(name, serviceLabels, namespace, metricsPortName, metricsPath='/metrics', prometheusInstance='application') = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    name: name,
    labels: {
      app: name,
      prometheus: prometheusInstance,
    },
  },
  spec: {
    endpoints: [
      {
        port: metricsPortName,
        path: metricsPath,
      },
    ],
    selector: {
      matchLabels: serviceLabels,
    },
    namespaceSelector: {
      matchNames: [
        namespace,
      ],
    },
  },
};


local podMonitor(name, podLabels, namespace, metricsPortName, metricsPath='/metrics', prometheusInstance='application') = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    name: name,
    labels: {
      app: name,
      prometheus: prometheusInstance,
    },
  },

  spec: {
    namespaceSelector: {
      matchNames: [
        namespace,
      ],
    },
    selector: {
      matchLabels: podLabels,
    },
    podMetricsEndpoints: [
      {
        port: metricsPortName,
        path: metricsPath,
      },
    ],
  },
};

{
  serviceMonitor:: serviceMonitor,
  podMonitor:: podMonitor,
}
