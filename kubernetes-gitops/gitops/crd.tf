



resource "kubernetes_manifest" "customresourcedefinition_canaries_flagger_app" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind"       = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "helm.sh/resource-policy" = "keep"
      }
      "name" = "canaries.flagger.app"
    }
    "spec" = {
      "additionalPrinterColumns" = [
        {
          "JSONPath" = ".status.phase"
          "name"     = "Status"
          "type"     = "string"
        },
        {
          "JSONPath" = ".status.canaryWeight"
          "name"     = "Weight"
          "type"     = "string"
        },
        {
          "JSONPath" = ".status.failedChecks"
          "name"     = "FailedChecks"
          "priority" = 1
          "type"     = "string"
        },
        {
          "JSONPath" = ".spec.analysis.interval"
          "name"     = "Interval"
          "priority" = 1
          "type"     = "string"
        },
        {
          "JSONPath" = ".spec.analysis.mirror"
          "name"     = "Mirror"
          "priority" = 1
          "type"     = "boolean"
        },
        {
          "JSONPath" = ".spec.analysis.stepWeight"
          "name"     = "StepWeight"
          "priority" = 1
          "type"     = "string"
        },
        {
          "JSONPath" = ".spec.analysis.maxWeight"
          "name"     = "MaxWeight"
          "priority" = 1
          "type"     = "string"
        },
        {
          "JSONPath" = ".status.lastTransitionTime"
          "name"     = "LastTransitionTime"
          "type"     = "string"
        },
      ]
      "group" = "flagger.app"
      "names" = {
        "categories" = [
          "all",
        ]
        "kind"     = "Canary"
        "plural"   = "canaries"
        "singular" = "canary"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "properties" = {
            "spec" = {
              "properties" = {
                "analysis" = {
                  "description" = "Canary analysis for this canary"
                  "oneOf" = [
                    {
                      "required" = [
                        "interval",
                        "threshold",
                        "iterations",
                      ]
                    },
                    {
                      "required" = [
                        "interval",
                        "threshold",
                        "stepWeight",
                      ]
                    },
                  ]
                  "properties" = {
                    "interval" = {
                      "description" = "Schedule interval for this canary"
                      "pattern"     = "^[0-9]+(m|s)"
                      "type"        = "string"
                    }
                    "iterations" = {
                      "description" = "Number of checks to run for A/B Testing and Blue/Green"
                      "type"        = "number"
                    }
                    "match" = {
                      "description" = "A/B testing match conditions"
                      "items" = {
                        "properties" = {
                          "headers" = {
                            "additionalProperties" = {
                              "oneOf" = [
                                {
                                  "required" = [
                                    "exact",
                                  ]
                                },
                                {
                                  "required" = [
                                    "prefix",
                                  ]
                                },
                                {
                                  "required" = [
                                    "suffix",
                                  ]
                                },
                                {
                                  "required" = [
                                    "regex",
                                  ]
                                },
                              ]
                              "properties" = {
                                "exact" = {
                                  "format" = "string"
                                  "type"   = "string"
                                }
                                "prefix" = {
                                  "format" = "string"
                                  "type"   = "string"
                                }
                                "regex" = {
                                  "description" = "RE2 style regex-based match (https://github.com/google/re2/wiki/Syntax)"
                                  "format"      = "string"
                                  "type"        = "string"
                                }
                                "suffix" = {
                                  "format" = "string"
                                  "type"   = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "type" = "object"
                          }
                          "sourceLabels" = {
                            "additionalProperties" = {
                              "format" = "string"
                              "type"   = "string"
                            }
                            "description" = "Applicable only when the 'mesh' gateway is included in the service.gateways list"
                            "type"        = "object"
                          }
                        }
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "maxWeight" = {
                      "description" = "Max traffic percentage routed to canary"
                      "type"        = "number"
                    }
                    "metrics" = {
                      "description" = "Metric check list for this canary"
                      "items" = {
                        "properties" = {
                          "interval" = {
                            "description" = "Interval of the query"
                            "pattern"     = "^[0-9]+(m|s)"
                            "type"        = "string"
                          }
                          "name" = {
                            "description" = "Name of the metric"
                            "type"        = "string"
                          }
                          "query" = {
                            "description" = "Prometheus query"
                            "type"        = "string"
                          }
                          "templateRef" = {
                            "description" = "Metric template reference"
                            "properties" = {
                              "name" = {
                                "description" = "Name of this metric template"
                                "type"        = "string"
                              }
                              "namespace" = {
                                "description" = "Namespace of this metric template"
                                "type"        = "string"
                              }
                            }
                            "required" = [
                              "name",
                            ]
                            "type" = "object"
                          }
                          "threshold" = {
                            "description" = "Max value accepted for this metric"
                            "type"        = "number"
                          }
                          "thresholdRange" = {
                            "description" = "Range accepted for this metric"
                            "properties" = {
                              "max" = {
                                "description" = "Max value accepted for this metric"
                                "type"        = "number"
                              }
                              "min" = {
                                "description" = "Min value accepted for this metric"
                                "type"        = "number"
                              }
                            }
                            "type" = "object"
                          }
                        }
                        "required" = [
                          "name",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "mirror" = {
                      "description" = "Mirror traffic to canary"
                      "type"        = "boolean"
                    }
                    "mirrorWeight" = {
                      "description" = "Percentage of traffic to be mirrored"
                      "type"        = "number"
                    }
                    "stepWeight" = {
                      "description" = "Incremental traffic percentage step for the analysis phase"
                      "type"        = "number"
                    }
                    "stepWeightPromotion" = {
                      "description" = "Incremental traffic percentage step for the promotion phase"
                      "type"        = "number"
                    }
                    "threshold" = {
                      "description" = "Max number of failed checks before rollback"
                      "type"        = "number"
                    }
                    "webhooks" = {
                      "description" = "Webhook list for this canary"
                      "items" = {
                        "properties" = {
                          "metadata" = {
                            "additionalProperties" = {
                              "type" = "string"
                            }
                            "description" = "Metadata (key-value pairs) for this webhook"
                            "type"        = "object"
                          }
                          "name" = {
                            "description" = "Name of the webhook"
                            "type"        = "string"
                          }
                          "timeout" = {
                            "description" = "Request timeout for this webhook"
                            "pattern"     = "^[0-9]+(m|s)"
                            "type"        = "string"
                          }
                          "type" = {
                            "description" = "Type of the webhook pre, post or during rollout"
                            "enum" = [
                              "",
                              "confirm-rollout",
                              "pre-rollout",
                              "rollout",
                              "confirm-promotion",
                              "post-rollout",
                              "event",
                              "rollback",
                            ]
                            "type" = "string"
                          }
                          "url" = {
                            "description" = "URL address of this webhook"
                            "format"      = "url"
                            "type"        = "string"
                          }
                        }
                        "required" = [
                          "name",
                          "url",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                  }
                  "type" = "object"
                }
                "autoscalerRef" = {
                  "description" = "HPA selector"
                  "properties" = {
                    "apiVersion" = {
                      "type" = "string"
                    }
                    "kind" = {
                      "enum" = [
                        "HorizontalPodAutoscaler",
                      ]
                      "type" = "string"
                    }
                    "name" = {
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "apiVersion",
                    "kind",
                    "name",
                  ]
                  "type" = "object"
                }
                "ingressRef" = {
                  "description" = "NGINX ingress selector"
                  "properties" = {
                    "apiVersion" = {
                      "type" = "string"
                    }
                    "kind" = {
                      "enum" = [
                        "Ingress",
                      ]
                      "type" = "string"
                    }
                    "name" = {
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "apiVersion",
                    "kind",
                    "name",
                  ]
                  "type" = "object"
                }
                "metricsServer" = {
                  "description" = "Prometheus URL"
                  "type"        = "string"
                }
                "progressDeadlineSeconds" = {
                  "description" = "Deployment progress deadline"
                  "type"        = "number"
                }
                "provider" = {
                  "description" = "Traffic managent provider"
                  "type"        = "string"
                }
                "revertOnDeletion" = {
                  "description" = "Revert mutated resources to original spec on deletion"
                  "type"        = "boolean"
                }
                "service" = {
                  "description" = "Kubernetes Service spec"
                  "properties" = {
                    "apex" = {
                      "description" = "Metadata to add to the apex service"
                      "properties" = {
                        "annotations" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                        "labels" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "backends" = {
                      "description" = "AppMesh backend array"
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "canary" = {
                      "description" = "Metadata to add to the canary service"
                      "properties" = {
                        "annotations" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                        "labels" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "corsPolicy" = {
                      "description" = "Istio Cross-Origin Resource Sharing policy (CORS)"
                      "properties" = {
                        "allowCredentials" = {
                          "type" = "boolean"
                        }
                        "allowHeaders" = {
                          "items" = {
                            "format" = "string"
                            "type"   = "string"
                          }
                          "type" = "array"
                        }
                        "allowMethods" = {
                          "description" = "List of HTTP methods allowed to access the resource"
                          "items" = {
                            "format" = "string"
                            "type"   = "string"
                          }
                          "type" = "array"
                        }
                        "allowOrigin" = {
                          "description" = "The list of origins that are allowed to perform CORS requests."
                          "items" = {
                            "format" = "string"
                            "type"   = "string"
                          }
                          "type" = "array"
                        }
                        "allowOrigins" = {
                          "description" = "String patterns that match allowed origins"
                          "items" = {
                            "oneOf" = [
                              {
                                "required" = [
                                  "exact",
                                ]
                              },
                              {
                                "required" = [
                                  "prefix",
                                ]
                              },
                              {
                                "required" = [
                                  "regex",
                                ]
                              },
                            ]
                            "properties" = {
                              "exact" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "prefix" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "regex" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "exposeHeaders" = {
                          "items" = {
                            "format" = "string"
                            "type"   = "string"
                          }
                          "type" = "array"
                        }
                        "maxAge" = {
                          "type" = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "gateways" = {
                      "description" = "The list of Istio gateway for this virtual service"
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "headers" = {
                      "description" = "Headers operations"
                      "properties" = {
                        "request" = {
                          "properties" = {
                            "add" = {
                              "additionalProperties" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "object"
                            }
                            "remove" = {
                              "items" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "array"
                            }
                            "set" = {
                              "additionalProperties" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "response" = {
                          "properties" = {
                            "add" = {
                              "additionalProperties" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "object"
                            }
                            "remove" = {
                              "items" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "array"
                            }
                            "set" = {
                              "additionalProperties" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "hosts" = {
                      "description" = "The list of host names for this service"
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "match" = {
                      "description" = "URI match conditions"
                      "items" = {
                        "properties" = {
                          "uri" = {
                            "oneOf" = [
                              {
                                "required" = [
                                  "exact",
                                ]
                              },
                              {
                                "required" = [
                                  "prefix",
                                ]
                              },
                              {
                                "required" = [
                                  "suffix",
                                ]
                              },
                              {
                                "required" = [
                                  "regex",
                                ]
                              },
                            ]
                            "properties" = {
                              "exact" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "prefix" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "regex" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "suffix" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                            }
                            "type" = "object"
                          }
                        }
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "meshName" = {
                      "description" = "AppMesh mesh name"
                      "type"        = "string"
                    }
                    "name" = {
                      "description" = "Kubernetes service name"
                      "type"        = "string"
                    }
                    "port" = {
                      "description" = "Container port number"
                      "type"        = "number"
                    }
                    "portDiscovery" = {
                      "description" = "Enable port dicovery"
                      "type"        = "boolean"
                    }
                    "portName" = {
                      "description" = "Container port name"
                      "type"        = "string"
                    }
                    "primary" = {
                      "description" = "Metadata to add to the primary service"
                      "properties" = {
                        "annotations" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                        "labels" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "retries" = {
                      "description" = "Retry policy for HTTP requests"
                      "properties" = {
                        "attempts" = {
                          "description" = "Number of retries for a given request"
                          "format"      = "int32"
                          "type"        = "integer"
                        }
                        "perTryTimeout" = {
                          "description" = "Timeout per retry attempt for a given request"
                          "type"        = "string"
                        }
                        "retryOn" = {
                          "description" = "Specifies the conditions under which retry takes place"
                          "format"      = "string"
                          "type"        = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "rewrite" = {
                      "description" = "Rewrite HTTP URIs"
                      "properties" = {
                        "uri" = {
                          "format" = "string"
                          "type"   = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "targetPort" = {
                      "anyOf" = [
                        {
                          "type" = "string"
                        },
                        {
                          "type" = "number"
                        },
                      ]
                      "description" = "Container target port name"
                    }
                    "timeout" = {
                      "description" = "HTTP or gRPC request timeout"
                      "type"        = "string"
                    }
                    "trafficPolicy" = {
                      "description" = "Istio traffic policy"
                      "properties" = {
                        "connectionPool" = {
                          "properties" = {
                            "http" = {
                              "description" = "HTTP connection pool settings."
                              "properties" = {
                                "h2UpgradePolicy" = {
                                  "description" = "Specify if http1.1 connection should be upgraded to http2 for the associated destination."
                                  "enum" = [
                                    "DEFAULT",
                                    "DO_NOT_UPGRADE",
                                    "UPGRADE",
                                  ]
                                  "type" = "string"
                                }
                                "http1MaxPendingRequests" = {
                                  "description" = "Maximum number of pending HTTP requests to a destination."
                                  "format"      = "int32"
                                  "type"        = "integer"
                                }
                                "http2MaxRequests" = {
                                  "description" = "Maximum number of requests to a backend."
                                  "format"      = "int32"
                                  "type"        = "integer"
                                }
                                "idleTimeout" = {
                                  "description" = "The idle timeout for upstream connection pool connections."
                                  "type"        = "string"
                                }
                                "maxRequestsPerConnection" = {
                                  "description" = "Maximum number of requests per connection to a backend."
                                  "format"      = "int32"
                                  "type"        = "integer"
                                }
                                "maxRetries" = {
                                  "format" = "int32"
                                  "type"   = "integer"
                                }
                              }
                              "type" = "object"
                            }
                          }
                        }
                        "loadBalancer" = {
                          "description" = "Settings controlling the load balancer algorithms."
                          "oneOf" = [
                            {
                              "required" = [
                                "simple",
                              ]
                            },
                            {
                              "properties" = {
                                "consistentHash" = {
                                  "oneOf" = [
                                    {
                                      "required" = [
                                        "httpHeaderName",
                                      ]
                                    },
                                    {
                                      "required" = [
                                        "httpCookie",
                                      ]
                                    },
                                    {
                                      "required" = [
                                        "useSourceIp",
                                      ]
                                    },
                                    {
                                      "required" = [
                                        "httpQueryParameterName",
                                      ]
                                    },
                                  ]
                                }
                              }
                              "required" = [
                                "consistentHash",
                              ]
                            },
                          ]
                          "properties" = {
                            "consistentHash" = {
                              "properties" = {
                                "httpCookie" = {
                                  "description" = "Hash based on HTTP cookie."
                                  "properties" = {
                                    "name" = {
                                      "description" = "Name of the cookie."
                                      "format"      = "string"
                                      "type"        = "string"
                                    }
                                    "path" = {
                                      "description" = "Path to set for the cookie."
                                      "format"      = "string"
                                      "type"        = "string"
                                    }
                                    "ttl" = {
                                      "description" = "Lifetime of the cookie."
                                      "type"        = "string"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "httpHeaderName" = {
                                  "description" = "Hash based on a specific HTTP header."
                                  "format"      = "string"
                                  "type"        = "string"
                                }
                                "httpQueryParameterName" = {
                                  "description" = "Hash based on a specific HTTP query parameter."
                                  "format"      = "string"
                                  "type"        = "string"
                                }
                                "minimumRingSize" = {
                                  "type" = "integer"
                                }
                                "useSourceIp" = {
                                  "description" = "Hash based on the source IP address."
                                  "type"        = "boolean"
                                }
                              }
                              "type" = "object"
                            }
                            "localityLbSetting" = {
                              "properties" = {
                                "distribute" = {
                                  "description" = "Optional: only one of distribute or failover can be set."
                                  "items" = {
                                    "properties" = {
                                      "from" = {
                                        "description" = "Originating locality, '/' separated, e.g."
                                        "format"      = "string"
                                        "type"        = "string"
                                      }
                                      "to" = {
                                        "additionalProperties" = {
                                          "type" = "integer"
                                        }
                                        "description" = "Map of upstream localities to traffic distribution weights."
                                        "type"        = "object"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "enabled" = {
                                  "description" = "enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety."
                                  "type"        = "boolean"
                                }
                                "failover" = {
                                  "description" = "Optional: only failover or distribute can be set."
                                  "items" = {
                                    "properties" = {
                                      "from" = {
                                        "description" = "Originating region."
                                        "format"      = "string"
                                        "type"        = "string"
                                      }
                                      "to" = {
                                        "format" = "string"
                                        "type"   = "string"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                            "simple" = {
                              "enum" = [
                                "ROUND_ROBIN",
                                "LEAST_CONN",
                                "RANDOM",
                                "PASSTHROUGH",
                              ]
                              "type" = "string"
                            }
                          }
                          "type" = "object"
                        }
                        "outlierDetection" = {
                          "description" = "Settings controlling eviction of unhealthy hosts from the load balancing pool."
                          "properties" = {
                            "baseEjectionTime" = {
                              "description" = "Minimum ejection duration."
                              "type"        = "string"
                            }
                            "consecutive5xxErrors" = {
                              "description" = "Number of 5xx errors before a host is ejected from the connection pool."
                              "type"        = "integer"
                            }
                            "consecutiveErrors" = {
                              "format" = "int32"
                              "type"   = "integer"
                            }
                            "consecutiveGatewayErrors" = {
                              "description" = "Number of gateway errors before a host is ejected from the connection pool."
                              "format"      = "int32"
                              "type"        = "integer"
                            }
                            "interval" = {
                              "description" = "Time interval between ejection sweep analysis."
                              "type"        = "string"
                            }
                            "maxEjectionPercent" = {
                              "format" = "int32"
                              "type"   = "integer"
                            }
                            "minHealthPercent" = {
                              "format" = "int32"
                              "type"   = "integer"
                            }
                          }
                          "type" = "object"
                        }
                        "tls" = {
                          "description" = "Istio TLS related settings for connections to the upstream service"
                          "properties" = {
                            "caCertificates" = {
                              "format" = "string"
                              "type"   = "string"
                            }
                            "clientCertificate" = {
                              "description" = "REQUIRED if mode is `MUTUAL`."
                              "format"      = "string"
                              "type"        = "string"
                            }
                            "mode" = {
                              "enum" = [
                                "DISABLE",
                                "SIMPLE",
                                "MUTUAL",
                                "ISTIO_MUTUAL",
                              ]
                              "type" = "string"
                            }
                            "privateKey" = {
                              "description" = "REQUIRED if mode is `MUTUAL`."
                              "format"      = "string"
                              "type"        = "string"
                            }
                            "sni" = {
                              "description" = "SNI string to present to the server during TLS handshake."
                              "format"      = "string"
                              "type"        = "string"
                            }
                            "subjectAltNames" = {
                              "items" = {
                                "format" = "string"
                                "type"   = "string"
                              }
                              "type" = "array"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                  }
                  "required" = [
                    "port",
                  ]
                  "type" = "object"
                }
                "skipAnalysis" = {
                  "description" = "Skip analysis and promote canary"
                  "type"        = "boolean"
                }
                "targetRef" = {
                  "description" = "Target selector"
                  "properties" = {
                    "apiVersion" = {
                      "type" = "string"
                    }
                    "kind" = {
                      "enum" = [
                        "DaemonSet",
                        "Deployment",
                        "Service",
                      ]
                      "type" = "string"
                    }
                    "name" = {
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "apiVersion",
                    "kind",
                    "name",
                  ]
                  "type" = "object"
                }
              }
              "required" = [
                "targetRef",
                "service",
                "analysis",
              ]
            }
            "status" = {
              "properties" = {
                "canaryWeight" = {
                  "description" = "Traffic weight percentage routed to canary"
                  "type"        = "number"
                }
                "conditions" = {
                  "description" = "Status conditions of this canary"
                  "items" = {
                    "properties" = {
                      "lastTransitionTime" = {
                        "description" = "LastTransitionTime of this condition"
                        "format"      = "date-time"
                        "type"        = "string"
                      }
                      "lastUpdateTime" = {
                        "description" = "LastUpdateTime of this condition"
                        "format"      = "date-time"
                        "type"        = "string"
                      }
                      "message" = {
                        "description" = "Message associated with this condition"
                        "type"        = "string"
                      }
                      "reason" = {
                        "description" = "Reason for the current status of this condition"
                        "type"        = "string"
                      }
                      "status" = {
                        "description" = "Status of this condition"
                        "type"        = "string"
                      }
                      "type" = {
                        "description" = "Type of this condition"
                        "type"        = "string"
                      }
                    }
                    "required" = [
                      "type",
                      "status",
                      "reason",
                    ]
                    "type" = "object"
                  }
                  "type" = "array"
                }
                "failedChecks" = {
                  "description" = "Failed check count of the current canary analysis"
                  "type"        = "number"
                }
                "iterations" = {
                  "description" = "Iteration count of the current canary analysis"
                  "type"        = "number"
                }
                "lastAppliedSpec" = {
                  "description" = "LastAppliedSpec of this canary"
                  "type"        = "string"
                }
                "lastTransitionTime" = {
                  "description" = "LastTransitionTime of this canary"
                  "format"      = "date-time"
                  "type"        = "string"
                }
                "phase" = {
                  "description" = "Analysis phase of this canary"
                  "enum" = [
                    "",
                    "Initializing",
                    "Initialized",
                    "Waiting",
                    "Progressing",
                    "Promoting",
                    "Finalising",
                    "Succeeded",
                    "Failed",
                    "Terminating",
                    "Terminated",
                  ]
                  "type" = "string"
                }
              }
            }
          }
        }
      }
      "version" = "v1beta1"
      "versions" = [
        {
          "name"    = "v1beta1"
          "served"  = true
          "storage" = true
        },
        {
          "name"    = "v1alpha3"
          "served"  = true
          "storage" = false
        },
        {
          "name"    = "v1alpha2"
          "served"  = false
          "storage" = false
        },
        {
          "name"    = "v1alpha1"
          "served"  = false
          "storage" = false
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_metrictemplates_flagger_app" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind"       = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "helm.sh/resource-policy" = "keep"
      }
      "name" = "metrictemplates.flagger.app"
    }
    "spec" = {
      "additionalPrinterColumns" = [
        {
          "JSONPath" = ".spec.provider.type"
          "name"     = "Provider"
          "type"     = "string"
        },
      ]
      "group" = "flagger.app"
      "names" = {
        "categories" = [
          "all",
        ]
        "kind"     = "MetricTemplate"
        "plural"   = "metrictemplates"
        "singular" = "metrictemplate"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "properties" = {
            "spec" = {
              "properties" = {
                "provider" = {
                  "description" = "Provider of this metric template"
                  "properties" = {
                    "address" = {
                      "description" = "API address of this provider"
                      "type"        = "string"
                    }
                    "region" = {
                      "description" = "Region of the provider"
                      "type"        = "string"
                    }
                    "secretRef" = {
                      "description" = "Kubernetes secret reference containing the provider credentials"
                      "properties" = {
                        "name" = {
                          "description" = "Name of the Kubernetes secret"
                          "type"        = "string"
                        }
                      }
                      "required" = [
                        "name",
                      ]
                      "type" = "object"
                    }
                    "type" = {
                      "description" = "Type of this provider"
                      "enum" = [
                        "prometheus",
                        "influxdb",
                        "datadog",
                        "cloudwatch",
                        "newrelic",
                      ]
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "type",
                  ]
                  "type" = "object"
                }
                "query" = {
                  "description" = "Query of this metric template"
                  "type"        = "string"
                }
              }
              "required" = [
                "provider",
                "query",
              ]
            }
          }
        }
      }
      "version" = "v1beta1"
      "versions" = [
        {
          "name"    = "v1beta1"
          "served"  = true
          "storage" = true
        },
        {
          "name"    = "v1alpha1"
          "served"  = true
          "storage" = false
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_alertproviders_flagger_app" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind"       = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "helm.sh/resource-policy" = "keep"
      }
      "name" = "alertproviders.flagger.app"
    }
    "spec" = {
      "additionalPrinterColumns" = [
        {
          "JSONPath" = ".spec.type"
          "name"     = "Type"
          "type"     = "string"
        },
      ]
      "group" = "flagger.app"
      "names" = {
        "categories" = [
          "all",
        ]
        "kind"     = "AlertProvider"
        "plural"   = "alertproviders"
        "singular" = "alertprovider"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "properties" = {
            "spec" = {
              "oneOf" = [
                {
                  "required" = [
                    "type",
                    "address",
                  ]
                },
                {
                  "required" = [
                    "type",
                    "secretRef",
                  ]
                },
              ]
              "properties" = {
                "address" = {
                  "description" = "Hook URL address of this provider"
                  "type"        = "string"
                }
                "secretRef" = {
                  "description" = "Kubernetes secret reference containing the provider address"
                  "properties" = {
                    "name" = {
                      "description" = "Name of the Kubernetes secret"
                      "type"        = "string"
                    }
                  }
                  "required" = [
                    "name",
                  ]
                  "type" = "object"
                }
                "type" = {
                  "description" = "Type of this provider"
                  "enum" = [
                    "slack",
                    "msteams",
                    "discord",
                    "rocket",
                  ]
                  "type" = "string"
                }
              }
            }
          }
        }
      }
      "version" = "v1beta1"
      "versions" = [
        {
          "name"    = "v1beta1"
          "served"  = true
          "storage" = true
        },
      ]
    }
  }
}
