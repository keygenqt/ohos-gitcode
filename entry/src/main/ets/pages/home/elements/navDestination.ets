import { PageNotFound } from '../../../base/components';
import { Pages } from '../../../base/constants';
import { PageRepo } from '../../repo/PageRepo';
import { PageRepoUpdate } from '../../repoUpdate/PageRepoUpdate';
import { PageUser } from '../../user/PageUser';

@Builder
export function navDestination(name: string, param: string) {
  if (name === Pages.repo) {
    PageRepo();
  } else if (name === Pages.repo_update) {
    PageRepoUpdate();
  } else if (name === Pages.user) {
    PageUser(param ? JSON.parse(param) : JSON.parse("{}"));
  } else {
    PageNotFound();
  }
}