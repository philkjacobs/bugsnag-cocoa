Feature: Stopping and resuming sessions

# TODO failing due to dupe requests?

Scenario: When a session is stopped the error has no session information
    When I run "StoppedSessionScenario"
    And I wait to receive 3 requests
    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier
    And I discard the oldest request

    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | null                   | The operation couldn’t be completed. (Second error error 101.) |
    
    And I discard the oldest request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | null                   | The operation couldn’t be completed. (Second error error 101.) |

Scenario: When a session is resumed the error uses the previous session information
    When I run "ResumedSessionScenario"
    And I wait to receive 3 requests
    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier
    
    And I discard the oldest request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | 2                      | The operation couldn’t be completed. (Second error error 101.) |

    And I discard the oldest request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | 2                      | The operation couldn’t be completed. (Second error error 101.) |

# TODO update for v2
    And the payload field "events.0.session.id" of request 1 equals the payload field "events.0.session.id" of request 2
    And the payload field "events.0.session.startedAt" of request 1 equals the payload field "events.0.session.startedAt" of request 2

Scenario: When a new session is started the error uses different session information
    When I run "NewSessionScenario"
    And I wait to receive 4 requests
    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier
    And I discard the oldest request
    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier

    And I discard the oldest request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | 1                      | The operation couldn’t be completed. (Second error error 101.) |

    And I discard the oldest request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the payload field matches one of:
        | session.events.handled | exceptions.0.message |
        | 1                      | The operation couldn’t be completed. (First error error 101.) |
        | 1                      | The operation couldn’t be completed. (Second error error 101.) |
    
# TODO update for v2
    And the payload field "events.0.session.id" of request 2 does not equal the payload field "events.0.session.id" of request 3
    
