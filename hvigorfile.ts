import { appTasks, OhosPluginId } from '@ohos/hvigor-ohos-plugin';
import { hvigor, HvigorNode, HvigorPlugin } from '@ohos/hvigor';

function localSecretPlugin(): HvigorPlugin {
  return {
    pluginId: 'localSecretPlugin',
    apply(node: HvigorNode) {
      hvigor.getRootNode().afterNodeEvaluate(root => {
        const fs = require('fs');
        const config = './local.secret.json5';
        if (fs.existsSync(config)) {
          const data = fs.readFileSync(config, 'utf-8');
          const secret = JSON.parse(data);
          const appCtx = root.getContext(OhosPluginId.OHOS_APP_PLUGIN) as OhosAppContext;
          const buildProfile = appCtx.getBuildProfileOpt();
          (buildProfile.app.products || []).forEach((prd: any) => {
            prd.buildOption.arkOptions.buildProfileFields.clientId = secret.clientId;
            prd.buildOption.arkOptions.buildProfileFields.clientSecret = secret.clientSecret;
            prd.buildOption.arkOptions.buildProfileFields.cryptoSecret = secret.cryptoSecret;
          });
          appCtx.setBuildProfileOpt(buildProfile);
        } else {
          console.warn(`> Not found file '${config}'`)
        }
      });
    }
  }
}

export default {
  system: appTasks, plugins: [localSecretPlugin()]
}