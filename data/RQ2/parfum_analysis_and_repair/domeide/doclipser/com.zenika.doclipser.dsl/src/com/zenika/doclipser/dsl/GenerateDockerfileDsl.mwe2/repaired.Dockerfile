module com.zenika.doclipser.dsl.GenerateDockerfileDsl

import org.eclipse.emf.mwe.utils.*
import org.eclipse.xtext.generator.*
import org.eclipse.xtext.ui.generator.*

var fileExtensions = "Dockerfile"
var projectName = "com.zenika.doclipser.dsl"
var runtimeProject = "../${projectName}"
//var grammarURI = "classpath:/com/zenika/doclipser/dsl/DockerfileDsl.xtext"
var grammarURI = "platform:/resource/${projectName}/src/com/zenika/doclipser/dsl/DockerfileDsl.xtext"
var generateXtendStub = true
var encoding = "UTF-8"

Workflow {
    bean = StandaloneSetup {
        // use an XtextResourceset throughout the process, which is able to resolve classpath:/ URIs.
        resourceSet = org.eclipse.xtext.resource.XtextResourceSet:theResourceSet {}
          
        // add mappings from platform:/resource to classpath:/
        uriMap = {
            from = "platform:/resource/org.eclipse.xtext.xbase/"
            to = "classpath:/"
        }
        uriMap = {
            from = "platform:/resource/org.eclipse.xtext.common.types/"
            to = "classpath:/"
          }
        
        platformUri = "${runtimeProject}/.."
        // The following two lines can be removed, if Xbase is not used.
        registerGeneratedEPackage = "org.eclipse.xtext.xbase.XbasePackage"
        registerGenModelFile = "platform:/resource/org.eclipse.xtext.xbase/model/Xbase.genmodel"
    }
    
    component = DirectoryCleaner {
        directory = "${runtimeProject}/src-gen"
    }
    
    component = DirectoryCleaner {
        directory = "${runtimeProject}/model/generated"
    }
    
    component = DirectoryCleaner {
        directory = "${runtimeProject}.ui/src-gen"
    }
    
    component = DirectoryCleaner {
        directory = "${runtimeProject}.tests/src-gen"
    }
    
    component = Generator {
        pathRtProject = runtimeProject
        pathUiProject = "${runtimeProject}.ui"
        pathTestProject = "${runtimeProject}.tests"
        projectNameRt = projectName
        projectNameUi = "${projectName}.ui"
        encoding = encoding
        language = auto-inject {
            uri = grammarURI
            forcedResourceSet = theResourceSet
    
            // Java API to access grammar elements (required by several other fragments)
            fragment = grammarAccess.GrammarAccessFragment auto-inject {}
    
            // generates Java API for the generated EPackages
            fragment = ecore.EMFGeneratorFragment auto-inject {}
    
            // the old serialization component
            // fragment = parseTreeConstructor.ParseTreeConstructorFragment auto-inject {}    
    
            // serializer 2.0
            fragment = serializer.SerializerFragment auto-inject {
                generateStub = false
            }
    
            // a custom ResourceFactory for use with EMF
            fragment = resourceFactory.ResourceFactoryFragment auto-inject {}
    
            // The antlr parser generator fragment.
            fragment = parser.antlr.XtextAntlrGeneratorFragment auto-inject {
            //  options = {
            //      backtrack = true
            //  }
            }
    
            // Xtend-based API for validation
            fragment = validation.ValidatorFragment auto-inject {
            //    composedCheck = "org.eclipse.xtext.validation.ImportUriValidator"
            //    composedCheck = "org.eclipse.xtext.validation.NamesAreUniqueValidator"
            }
    
            // old scoping and exporting API
            // fragment = scoping.ImportURIScopingFragment auto-inject {}
            // fragment = exporting.SimpleNamesFragment auto-inject {}
    
            // scoping and exporting API
            fragment = scoping.ImportNamespacesScopingFragment auto-inject {}
            fragment = exporting.QualifiedNamesFragment auto-inject {}
            fragment = builder.BuilderIntegrationFragment auto-inject {}
    
            // generator API
            fragment = generator.GeneratorFragment auto-inject {}
    
            // formatter API
            fragment = formatting.FormatterFragment auto-inject {}
    
            // labeling API
            fragment = labeling.LabelProviderFragment auto-inject {}
    
            // outline API
            fragment = outline.OutlineTreeProviderFragment auto-inject {}
            fragment = outline.QuickOutlineFragment auto-inject {}
    
            // quickfix API
            fragment = quickfix.QuickfixProviderFragment auto-inject {}
    
            // content assist API
            fragment = contentAssist.ContentAssistFragment auto-inject {}
    
            // generates a more lightweight Antlr parser and lexer tailored for content assist
            fragment = parser.antlr.XtextAntlrUiGeneratorFragment auto-inject {}
    
            // generates junit test support classes into Generator#pathTestProject
            fragment = junit.Junit4Fragment auto-inject {}
    
            // rename refactoring
            fragment = refactoring.RefactorElementNameFragment auto-inject {}
    
            // provides the necessary bindings for java types integration
            fragment = types.TypesGeneratorFragment auto-inject {}
    
            // generates the required bindings only if the grammar inherits from Xbase
            fragment = xbase.XbaseGeneratorFragment auto-inject {}
            
            // generates the required bindings only if the grammar inherits from Xtype
            fragment = xbase.XtypeGeneratorFragment auto-inject {}
    
            // provides a preference page for template proposals
            fragment = templates.CodetemplatesGeneratorFragment auto-inject {}
    
            // provides a compare view
            fragment = compare.CompareFragment auto-inject {}
        }
    }
}