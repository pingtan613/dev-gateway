## Gateway Policy Plugin CI/CD/CT Example
This repository contains an example of how to use the Policy Plugin in a CI/CD/CT Pipeline to promote, test and rollback any given changes to deployed API Gateways.

#### Getting Started
- TODO:

#### GitHub Actions
- TODO:
- Checkout the Actions tab to see what a run looks like.
- Test.

#### What's here today?
- 3 Environments (test, uat, production)
- 2 Service Projects (module2 + module1)
- 2 Environment Projects (common - global, module1-env)
- CI/CD/CT Pipeline
  - Build and Publish to Test, Run BlazeCT Functional Tests, Proceed onto UAT, Production if testing succeeds. (configurable)
  - GitHub Secrets used for credentials

#### Under development
- Portal integration
- Policy Repository + Index
- Environment (module1/module2) Specific deployment
- Global settings
- OTK Customisations
- ....

#### Under Consideration
- Delete bundles
- Deploy gateways and test before publishing

### Environment Details
Test - https://gateway-test.brcmlabs.com:8443
UAT - https://gateway-uat.brcmlabs.com:8443
Production - https://gateway-production.brcmlabs.com:8443

## License

Copyright (c) 2021 CA. All rights reserved.

This software may be modified and distributed under the terms
of the MIT license. See the [LICENSE][license-link] file for details.

 [license-link]: /LICENSE
 [contributing]: /CONTRIBUTING.md

