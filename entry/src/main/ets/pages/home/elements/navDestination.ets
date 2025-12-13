import { PageError404 } from '../../../base/components';
import { Pages } from '../../../base/constants';
import { PageRepo } from '../../repo/PageRepo';
import { PageUserUpdate } from '../../userUpdate/PageUserUpdate';
import { PageUser } from '../../user/PageUser';

@Builder
export function navDestination(name: string, param: string) {
  if (name === Pages.repo) {
    PageRepo(param ? JSON.parse(param) : JSON.parse("{}"));
  } else if (name === Pages.user_update) {
    PageUserUpdate(param ? JSON.parse(param) : JSON.parse("{}"));
  } else if (name === Pages.user) {
    PageUser(param ? JSON.parse(param) : JSON.parse("{}"));
  } else {
    PageError404()
  }
}