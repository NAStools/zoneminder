<?php
App::uses('AppController', 'Controller');
/**
 * Zones Controller
 *
 * @property Zone $Zone
 */
class ZonesController extends AppController {

// Find all zones which belong to a MonitorId
	public function forMonitor($id = null) {
		$this->loadModel('Monitor');
		if (!$this->Monitor->exists($id)) {
			throw new NotFoundException(__('Invalid monitor'));
		}

		$this->Zone->recursive = -1;

		$zones = $this->Zone->find('all', array(
			'conditions' => array('MonitorId' => $id)
		));
		$this->set(array(
			'zones' => $zones,
			'_serialize' => array('zones')
		));
	}
/**
 * add method
 *
 * @return void
 */
	public function add() {
		if ($this->request->is('post')) {
			$this->Zone->create();
			if ($this->Zone->save($this->request->data)) {
				return $this->flash(__('The zone has been saved.'), array('action' => 'index'));
			}
		}
		$monitors = $this->Zone->Monitor->find('list');
		$this->set(compact('monitors'));
	}

/**
 * edit method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function edit($id = null) {
		$this->Zone->id = $id;

		if (!$this->Zone->exists($id)) {
			throw new NotFoundException(__('Invalid zone'));
		}
		if ($this->request->is(array('post', 'put'))) {
			if ($this->Zone->save($this->request->data)) {
				return $this->flash(__('The zone has been saved.'), array('action' => 'index'));
			}
		} else {
			$options = array('conditions' => array('Zone.' . $this->Zone->primaryKey => $id));
			$this->request->data = $this->Zone->find('first', $options);
		}
		$monitors = $this->Zone->Monitor->find('list');
		$this->set(compact('monitors'));
	}

/**
 * delete method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function delete($id = null) {
		$this->Zone->id = $id;
		if (!$this->Zone->exists()) {
			throw new NotFoundException(__('Invalid zone'));
		}
		$this->request->allowMethod('post', 'delete');
		if ($this->Zone->delete()) {
			return $this->flash(__('The zone has been deleted.'), array('action' => 'index'));
		} else {
			return $this->flash(__('The zone could not be deleted. Please, try again.'), array('action' => 'index'));
		}
	}



	public function createZoneImage( $id = null ) {
		$this->loadModel('Monitor');
		$this->Monitor->id = $id;
		if (!$this->Monitor->exists()) {
			throw new NotFoundException(__('Invalid zone'));
		}


		$this->loadModel('Config');
		$zm_dir_images = $this->Config->find('list', array(
			'conditions' => array('Name' => 'ZM_DIR_IMAGES'),
			'fields' => array('Name', 'Value')
		));

		$zm_dir_images = $zm_dir_images['ZM_DIR_IMAGES'];
		$zm_path_web = Configure::read('ZM_PATH_WEB');
		$zm_path_bin = Configure::read('ZM_PATH_BIN');
		$images_path = "$zm_path_web/$zm_dir_images";

		chdir($images_path);

		$command = escapeshellcmd("$zm_path_bin/zmu -z -m $id");
		system( $command, $status );

		$this->set(array(
			'status' => $status,
			'_serialize' => array('status')
		));

	}
}
