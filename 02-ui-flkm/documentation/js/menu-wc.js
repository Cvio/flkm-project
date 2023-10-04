'use strict';

customElements.define('compodoc-menu', class extends HTMLElement {
    constructor() {
        super();
        this.isNormalMode = this.getAttribute('mode') === 'normal';
    }

    connectedCallback() {
        this.render(this.isNormalMode);
    }

    render(isNormalMode) {
        let tp = lithtml.html(`
        <nav>
            <ul class="list">
                <li class="title">
                    <a href="index.html" data-type="index-link">02-ui-flkm documentation</a>
                </li>

                <li class="divider"></li>
                ${ isNormalMode ? `<div id="book-search-input" role="search"><input type="text" placeholder="Type to search"></div>` : '' }
                <li class="chapter">
                    <a data-type="chapter-link" href="index.html"><span class="icon ion-ios-home"></span>Getting started</a>
                    <ul class="links">
                        <li class="link">
                            <a href="overview.html" data-type="chapter-link">
                                <span class="icon ion-ios-keypad"></span>Overview
                            </a>
                        </li>
                        <li class="link">
                            <a href="index.html" data-type="chapter-link">
                                <span class="icon ion-ios-paper"></span>README
                            </a>
                        </li>
                                <li class="link">
                                    <a href="dependencies.html" data-type="chapter-link">
                                        <span class="icon ion-ios-list"></span>Dependencies
                                    </a>
                                </li>
                                <li class="link">
                                    <a href="properties.html" data-type="chapter-link">
                                        <span class="icon ion-ios-apps"></span>Properties
                                    </a>
                                </li>
                    </ul>
                </li>
                    <li class="chapter modules">
                        <a data-type="chapter-link" href="modules.html">
                            <div class="menu-toggler linked" data-bs-toggle="collapse" ${ isNormalMode ?
                                'data-bs-target="#modules-links"' : 'data-bs-target="#xs-modules-links"' }>
                                <span class="icon ion-ios-archive"></span>
                                <span class="link-name">Modules</span>
                                <span class="icon ion-ios-arrow-down"></span>
                            </div>
                        </a>
                        <ul class="links collapse " ${ isNormalMode ? 'id="modules-links"' : 'id="xs-modules-links"' }>
                            <li class="link">
                                <a href="modules/AppModule.html" data-type="entity-link" >AppModule</a>
                                    <li class="chapter inner">
                                        <div class="simple menu-toggler" data-bs-toggle="collapse" ${ isNormalMode ?
                                            'data-bs-target="#components-links-module-AppModule-b07be55357e61d3c2a3e977730d4a4d02ebab04d47ec199b5ff8d75755198cb1cd604dac340550754bd93aeeec3f706b2cee2788da5820bf211b1d1a51e00360"' : 'data-bs-target="#xs-components-links-module-AppModule-b07be55357e61d3c2a3e977730d4a4d02ebab04d47ec199b5ff8d75755198cb1cd604dac340550754bd93aeeec3f706b2cee2788da5820bf211b1d1a51e00360"' }>
                                            <span class="icon ion-md-cog"></span>
                                            <span>Components</span>
                                            <span class="icon ion-ios-arrow-down"></span>
                                        </div>
                                        <ul class="links collapse" ${ isNormalMode ? 'id="components-links-module-AppModule-b07be55357e61d3c2a3e977730d4a4d02ebab04d47ec199b5ff8d75755198cb1cd604dac340550754bd93aeeec3f706b2cee2788da5820bf211b1d1a51e00360"' :
                                            'id="xs-components-links-module-AppModule-b07be55357e61d3c2a3e977730d4a4d02ebab04d47ec199b5ff8d75755198cb1cd604dac340550754bd93aeeec3f706b2cee2788da5820bf211b1d1a51e00360"' }>
                                            <li class="link">
                                                <a href="components/AppComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >AppComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/CreateProjectComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >CreateProjectComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/DashboardComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >DashboardComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/FlnProjectButtonComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >FlnProjectButtonComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/LoginComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >LoginComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/MarketplaceComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >MarketplaceComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/RegistrationComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >RegistrationComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/RegistrationConfirmationComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >RegistrationConfirmationComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/ResourceListComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >ResourceListComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/UploadResourceComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >UploadResourceComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/UserWalletComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >UserWalletComponent</a>
                                            </li>
                                            <li class="link">
                                                <a href="components/VerifyEmailComponent.html" data-type="entity-link" data-context="sub-entity" data-context-id="modules" >VerifyEmailComponent</a>
                                            </li>
                                        </ul>
                                    </li>
                            </li>
                            <li class="link">
                                <a href="modules/AppRoutingModule.html" data-type="entity-link" >AppRoutingModule</a>
                            </li>
                </ul>
                </li>
                    <li class="chapter">
                        <div class="simple menu-toggler" data-bs-toggle="collapse" ${ isNormalMode ? 'data-bs-target="#components-links"' :
                            'data-bs-target="#xs-components-links"' }>
                            <span class="icon ion-md-cog"></span>
                            <span>Components</span>
                            <span class="icon ion-ios-arrow-down"></span>
                        </div>
                        <ul class="links collapse " ${ isNormalMode ? 'id="components-links"' : 'id="xs-components-links"' }>
                            <li class="link">
                                <a href="components/AccessControlComponent.html" data-type="entity-link" >AccessControlComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/AccountBalanceComponent.html" data-type="entity-link" >AccountBalanceComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/CollaborationDetailsComponent.html" data-type="entity-link" >CollaborationDetailsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/CollaborationListComponent.html" data-type="entity-link" >CollaborationListComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ComplianceComponent.html" data-type="entity-link" >ComplianceComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ContributionComponent.html" data-type="entity-link" >ContributionComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/DataMonetizationTermsComponent.html" data-type="entity-link" >DataMonetizationTermsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/DatasetUploadComponent.html" data-type="entity-link" >DatasetUploadComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/DataTrackingComponent.html" data-type="entity-link" >DataTrackingComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/EncryptionComponent.html" data-type="entity-link" >EncryptionComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/FilecoinDataStorageComponent.html" data-type="entity-link" >FilecoinDataStorageComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/FooterComponent.html" data-type="entity-link" >FooterComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/IPFSDataStorageComponent.html" data-type="entity-link" >IPFSDataStorageComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ModalDialogComponent.html" data-type="entity-link" >ModalDialogComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ModelAccessControlComponent.html" data-type="entity-link" >ModelAccessControlComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ModelDetailsComponent.html" data-type="entity-link" >ModelDetailsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ModelListComponent.html" data-type="entity-link" >ModelListComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ModelVersionControlComponent.html" data-type="entity-link" >ModelVersionControlComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/NavigationBarComponent.html" data-type="entity-link" >NavigationBarComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/PayoutRequestComponent.html" data-type="entity-link" >PayoutRequestComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ProjectDetailsComponent.html" data-type="entity-link" >ProjectDetailsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ProjectListComponent.html" data-type="entity-link" >ProjectListComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ProjectParticipantsComponent.html" data-type="entity-link" >ProjectParticipantsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/ResourceDetailsComponent.html" data-type="entity-link" >ResourceDetailsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/RewardsComponent.html" data-type="entity-link" >RewardsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/SetEvaluationCriteriaComponent.html" data-type="entity-link" >SetEvaluationCriteriaComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/SmartContractsComponent.html" data-type="entity-link" >SmartContractsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/StartTrainingComponent.html" data-type="entity-link" >StartTrainingComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/StopTrainingComponent.html" data-type="entity-link" >StopTrainingComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/TrainingResultsComponent.html" data-type="entity-link" >TrainingResultsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/TransactionRecordsComponent.html" data-type="entity-link" >TransactionRecordsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/UploadModelsComponent.html" data-type="entity-link" >UploadModelsComponent</a>
                            </li>
                            <li class="link">
                                <a href="components/UserProfileComponent.html" data-type="entity-link" >UserProfileComponent</a>
                            </li>
                        </ul>
                    </li>
                        <li class="chapter">
                            <div class="simple menu-toggler" data-bs-toggle="collapse" ${ isNormalMode ? 'data-bs-target="#injectables-links"' :
                                'data-bs-target="#xs-injectables-links"' }>
                                <span class="icon ion-md-arrow-round-down"></span>
                                <span>Injectables</span>
                                <span class="icon ion-ios-arrow-down"></span>
                            </div>
                            <ul class="links collapse " ${ isNormalMode ? 'id="injectables-links"' : 'id="xs-injectables-links"' }>
                                <li class="link">
                                    <a href="injectables/AccessControlService.html" data-type="entity-link" >AccessControlService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/AccessControlService-1.html" data-type="entity-link" >AccessControlService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/AccountBalanceService.html" data-type="entity-link" >AccountBalanceService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/CollaborationDetailsService.html" data-type="entity-link" >CollaborationDetailsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/CollaborationListService.html" data-type="entity-link" >CollaborationListService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ComplianceService.html" data-type="entity-link" >ComplianceService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ContributionService.html" data-type="entity-link" >ContributionService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/DashboardService.html" data-type="entity-link" >DashboardService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/DataMonetizationTermsService.html" data-type="entity-link" >DataMonetizationTermsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/DatasetUploadService.html" data-type="entity-link" >DatasetUploadService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/DataTrackingService.html" data-type="entity-link" >DataTrackingService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/EncryptionService.html" data-type="entity-link" >EncryptionService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/FilecoinDataStorageService.html" data-type="entity-link" >FilecoinDataStorageService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/FooterService.html" data-type="entity-link" >FooterService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/IPFSDataStorageService.html" data-type="entity-link" >IPFSDataStorageService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/LoginService.html" data-type="entity-link" >LoginService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/MarketplaceService.html" data-type="entity-link" >MarketplaceService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ModalDialogService.html" data-type="entity-link" >ModalDialogService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ModelAccessControlService.html" data-type="entity-link" >ModelAccessControlService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ModelDetailsService.html" data-type="entity-link" >ModelDetailsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ModelListService.html" data-type="entity-link" >ModelListService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ModelVersionControlService.html" data-type="entity-link" >ModelVersionControlService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/NavigationBarService.html" data-type="entity-link" >NavigationBarService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/PayoutRequestService.html" data-type="entity-link" >PayoutRequestService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ProjectDetailsService.html" data-type="entity-link" >ProjectDetailsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ProjectListService.html" data-type="entity-link" >ProjectListService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ProjectParticipantsService.html" data-type="entity-link" >ProjectParticipantsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ProjectService.html" data-type="entity-link" >ProjectService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/RegistrationService.html" data-type="entity-link" >RegistrationService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ResourceDetailsService.html" data-type="entity-link" >ResourceDetailsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/ResourceListService.html" data-type="entity-link" >ResourceListService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/RewardsService.html" data-type="entity-link" >RewardsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/SetEvaluationCriteriaService.html" data-type="entity-link" >SetEvaluationCriteriaService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/SharedService.html" data-type="entity-link" >SharedService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/SmartContractsService.html" data-type="entity-link" >SmartContractsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/StartTrainingService.html" data-type="entity-link" >StartTrainingService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/StopTrainingService.html" data-type="entity-link" >StopTrainingService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/TrainingResultsService.html" data-type="entity-link" >TrainingResultsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/TransactionRecordsService.html" data-type="entity-link" >TransactionRecordsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/UploadModelsService.html" data-type="entity-link" >UploadModelsService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/UploadResourceService.html" data-type="entity-link" >UploadResourceService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/UserProfileService.html" data-type="entity-link" >UserProfileService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/UserService.html" data-type="entity-link" >UserService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/VerifyEmailService.html" data-type="entity-link" >VerifyEmailService</a>
                                </li>
                                <li class="link">
                                    <a href="injectables/WalletService.html" data-type="entity-link" >WalletService</a>
                                </li>
                            </ul>
                        </li>
                        <li class="chapter">
                            <a data-type="chapter-link" href="routes.html"><span class="icon ion-ios-git-branch"></span>Routes</a>
                        </li>
                    <li class="chapter">
                        <a data-type="chapter-link" href="coverage.html"><span class="icon ion-ios-stats"></span>Documentation coverage</a>
                    </li>
                    <li class="divider"></li>
                    <li class="copyright">
                        Documentation generated using <a href="https://compodoc.app/" target="_blank" rel="noopener noreferrer">
                            <img data-src="images/compodoc-vectorise.png" class="img-responsive" data-type="compodoc-logo">
                        </a>
                    </li>
            </ul>
        </nav>
        `);
        this.innerHTML = tp.strings;
    }
});