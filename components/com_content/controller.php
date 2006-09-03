<?php
/**
 * @version $Id$
 * @package Joomla
 * @subpackage Content
 * @copyright Copyright (C) 2005 - 2006 Open Source Matters. All rights reserved.
 * @license GNU/GPL, see LICENSE.php
 * Joomla! is free software. This version may have been modified pursuant to the
 * GNU General Public License, and as distributed it includes or is derivative
 * of works licensed under the GNU General Public License or other free or open
 * source software licenses. See COPYRIGHT.php for copyright notices and
 * details.
 */

jimport('joomla.application.controller');

/**
 * Content Component Controller
 *
 * @package Joomla
 * @subpackage Content
 * @since 1.5
 */
class ContentController extends JController
{
	/**
	 * Method to show an article as the main page display
	 *
	 * @access	public
	 * @since	1.5
	 */
	function display()
	{
		$document =& JFactory::getDocument();
		$cParams= JSiteHelper::getControlParams();

		$viewName	= JRequest::getVar('view', $cParams->get( 'view_name' ));
		$viewType   = $document->getType();
		$modelName	= JRequest::getVar('model', $cParams->get( 'model_name', $viewName ));
		$layout     = $cParams->get( 'template_name' );

		// interceptors to support legacy urls
		switch( $this->getTask())
		{
			//index.php?option=com_content&task=blogsection&id=0&Itemid=4
			case 'blogsection':
				$viewName	= 'section';
				$modelName	= 'section';
				$layout = 'blog';
				break;
			case 'section':
				$viewName	= 'section';
				$modelName	= 'section';
				$layout = 'list';
				break;
			case 'category':
				$viewName	= 'category';
				$modelName	= 'category';
				$layout = 'table';
				break;
			case 'blogcategory':
				$viewName	= 'section';
				$modelName	= 'section';
				$layout = 'blog';
				break;
			case 'archivesection':
			case 'archivecategory':
				$viewName	= 'archive';
				$modelName	= 'archive';
				$layout = 'list';
				break;
			case 'frontpage' :
				$viewName = 'frontpage';
				$modelName = 'frontpage';
				$layout = 'blog';
				break;
			case 'view':
				$viewName	= 'article';
				$modelName	= 'article';
				$layout = 'article';
				break;
		}


		// Create the view
		$this->setViewName( $viewName, 'ContentView', $viewType );
		$view = & $this->getView();

		// Get/Create the model
		$model = & $this->getModel($modelName, 'ContentModel');

		// Push the model into the view (as default)
		$view->setModel($model, true);

		// Display the view
		$view->display($layout);
	}

	/**
	* Edits an article
	*
	* @access	public
	* @since	1.5
	*/
	function edit()
	{
		// Set the view name to article view
		$this->setViewName( 'article', 'ContentView', 'html' );

		// Create the view
		$view = & $this->getView();

		// Get/Create the model
		$model = & $this->getModel('Article', 'ContentModel');

		// Get the id of the article to display and set the model
		$id = JRequest::getVar('id', 0, '', 'int');
		$model->setId($id);

		// Push the model into the view (as default)
		$view->setModel($model, true);
		// Display the view
		$view->edit();
	}

	/**
	* Saves the content item an edit form submit
	*
	* @todo
	*/
	function save()
	{
		global $Itemid, $mainframe;

		// Initialize variables
		$db			= & JFactory::getDBO();
		$user		= & JFactory::getUser();
		$nullDate	= $db->getNullDate();
		$task		= JRequest::getVar('task');

		/*
		 * Create a user access object for the user
		 */
		$access					= new stdClass();
		$access->canEdit		= $user->authorize('action', 'edit', 'content', 'all');
		$access->canEditOwn		= $user->authorize('action', 'edit', 'content', 'own');
		$access->canPublish		= $user->authorize('action', 'publish', 'content', 'all');

		$row = & JTable::getInstance('content', $db);
		if (!$row->bind($_POST)) {
			JError::raiseError( 500, $row->getError());
		}

		// sanitise id field
		$row->id = (int) $row->id;

		$isNew = ($row->id < 1);
		if ($isNew)
		{
			// new record
			if (!($access->canEdit || $access->canEditOwn)) {
				JError::raiseError( 403, JText::_("ALERTNOTAUTH") );
			}
			$row->created 		= date('Y-m-d H:i:s');
			$row->created_by 	= $user->get('id');
		}
		else
		{
			// existing record
			if (!($access->canEdit || ($access->canEditOwn && $row->created_by == $user->get('id')))) {
				JError::raiseError( 403, JText::_("ALERTNOTAUTH") );
			}
			$row->modified 		= date('Y-m-d H:i:s');
			$row->modified_by 	= $user->get('id');
		}

		// Append time if not added to publish date
		if (strlen(trim($row->publish_up)) <= 10) {
			$row->publish_up .= ' 00:00:00';
		}
		$row->publish_up = mosFormatDate($row->publish_up, '%Y-%m-%d %H:%M:%S', - $mainframe->getCfg('offset'));

		// Handle never unpublish date
		if (trim($row->publish_down) == 'Never' || trim( $row->publish_down ) == '') {
			$row->publish_down = $nullDate;
		} else {
			if (strlen(trim( $row->publish_down )) <= 10) {
				$row->publish_down .= ' 00:00:00';
			}
			$row->publish_down = mosFormatDate($row->publish_down, '%Y-%m-%d %H:%M:%S', - $mainframe->getCfg('offset'));
		}

		$row->title = ampReplace($row->title);

		// Publishing state hardening for Authors
		if (!$access->canPublish)
		{
			if ($isNew)
			{
				// For new items - author is not allowed to publish - prevent them from doing so
				$row->state = 0;
			}
			else
			{
				// For existing items keep existing state - author is not allowed to change status
				$query = "SELECT state" .
						"\n FROM #__content" .
						"\n WHERE id = $row->id";
				$db->setQuery($query);
				$state = $db->loadResult();

				if ($state)
				{
					$row->state = 1;
				}
				else
				{
					$row->state = 0;
				}
			}
		}

		// Prepare content  for save
		JContentHelper::saveContentPrep($row);

		if (!$row->check()) {
			JError::raiseError( 500, $row->getError());
		}
		$row->version++;
		if (!$row->store()) {
			JError::raiseError( 500, $row->getError());
		}

		// manage frontpage items
		//TODO : Move this into a frontpage model
		require_once (JPATH_ADMINISTRATOR.DS.'components'.DS.'com_frontpage'.DS.'tables'.DS.'frontpage.php');
		$fp = new TableFrontPage($db);

		if (JRequest::getVar('frontpage', false, '', 'boolean'))
		{
			// toggles go to first place
			if (!$fp->load($row->id))
			{
				// new entry
				$query = "INSERT INTO #__content_frontpage" .
						"\n VALUES ( $row->id, 1 )";
				$db->setQuery($query);
				if (!$db->query()) {
					JError::raiseError( 500, $db->stderror());
				}
				$fp->ordering = 1;
			}
		}
		else
		{
			// no frontpage mask
			if (!$fp->delete($row->id)) {
				$msg .= $fp->stderr();
			}
			$fp->ordering = 0;
		}
		$fp->reorder();

		$row->checkin();
		$row->reorder("catid = " . (int) $row->catid );

		// gets section name of item
		$query = "SELECT s.title" .
				"\n FROM #__sections AS s" .
				"\n WHERE s.scope = 'content'" .
				"\n AND s.id = " . (int) $row->sectionid;
		$db->setQuery($query);
		// gets category name of item
		$section = $db->loadResult();

		$query = "SELECT c.title" .
				"\n FROM #__categories AS c" .
				"\n WHERE c.id = " . (int) $row->catid;
		$db->setQuery($query);
		$category = $db->loadResult();

		if ($isNew)
		{
			// messaging for new items
			require_once (JPATH_ADMINISTRATOR.'/components/com_messages/tables/message.php');
			$query = "SELECT id" .
					"\n FROM #__users" .
					"\n WHERE sendEmail = 1";
			$db->setQuery($query);
			$users = $db->loadResultArray();
			foreach ($users as $user_id)
			{
				jimport('joomla.utilities.message');
				$msg = new JMessage($db);
				$msg->send($user->get('id'), $user_id, "New Item", sprintf(JText::_('ON_NEW_CONTENT'), $user->get('username'), $row->title, $section, $category));
			}
		}

		$msg = $isNew ? JText::_('THANK_SUB') : JText::_('Item successfully saved.');
		$msg = $user->get('usertype') == 'Publisher' ? JText::_('THANK_SUB') : $msg;
		switch ($task)
		{
			case 'apply' :
				$link = $_SERVER['HTTP_REFERER'];
				break;

			case 'apply_new' :
				$Itemid = JRequest::getVar('Returnid', $Itemid, 'post');
				$link = 'index.php?option=com_content&task=edit&id='.$row->id.'&Itemid='.$Itemid;
				break;

			case 'save' :
			default :
				$Itemid = JRequest::getVar('Returnid', '', 'post');
				if ($Itemid)
				{
					$link = 'index.php?option=com_content&task=view&id='.$row->id.'&Itemid='.$Itemid;
				}
				else
				{
					$link = JRequest::getVar('referer', '', 'post');
				}
				break;
		}
		$mainframe->redirect($link, $msg);
	}

	/**
	* Cancels an edit article operation
	*
	* @access	public
	* @since	1.5
	*/
	function cancel()
	{
		// Initialize some variables
		$db		= & JFactory::getDBO();
		$user	= & JFactory::getUser();

		// At some point in the future these will be in a request object
		$Itemid		= JRequest::getVar('Returnid', '0', 'post');
		$referer	= JRequest::getVar('referer', '', 'post');

		// Get an article table object and bind post variabes to it [We don't need a full model here]
		$article = & JTable::getInstance('content', $db);
		$article->bind($_POST);

		if ($user->authorize('action', 'edit', 'content', 'all') || ($user->authorize('action', 'edit', 'content', 'own') && $article->created_by == $user->get('id'))) {
			$article->checkin();
		}

		// If the task was edit or cancel, we go back to the content item
		if ($this->_task == 'edit' || $this->_task == 'cancel') {
			$referer = 'index.php?option=com_content&task=view&id='.$article->id.'&Itemid='.$Itemid;
		}

		// If the task was not new, we go back to the referrer
		if ($referer && $article->id) {
			$this->setRedirect($referer);
		}
		else {
			$this->setRedirect('index.php');
		}
	}

	/**
	* Rates an article
	*
	* @access	public
	* @since	1.5
	*/
	function vote()
	{
		$url	= JRequest::getVar('url', '');
		$rating	= JRequest::getVar('user_rating', 0, '', 'int');
		$id		= JRequest::getVar('cid', 0, '', 'int');

		// Get/Create the model
		$model = & $this->getModel('Article', 'ContentModel');

		$model->setId($id);
		if ($model->storeVote($rating)) {
			$this->setRedirect($url, JText::_('Thanks for your vote!'));
		} else {
			$this->setRedirect($url, JText::_('You already voted for this poll today!'));
		}
	}

	/**
	 * Searches for an item by a key parameter
	 *
	 * @access	public
	 * @since	1.5
	 */
	function findkey()
	{
		// Initialize variables
		$db		= & JFactory::getDBO();
		$keyref	= $db->getEscaped(JRequest::getVar('keyref'));

		$query = "SELECT id" .
				"\n FROM #__content" .
				"\n WHERE attribs LIKE '%keyref=$keyref%'";
		$db->setQuery($query);
		$id = $db->loadResult();
		if ($id > 0) {
			// Set the view name to article view
			$this->setViewName( 'article', 'ContentView', 'html' );

			// Create the view
			$view = & $this->getView();

			// Get/Create the model
			$model = & $this->getModel('Article', 'ContentModel');

			// Get the id of the article to display and set the model
			$id = JRequest::getVar('id', 0, '', 'int');
			$model->setId($id);

			// Push the model into the view (as default)
			$view->setModel($model, true);
			// Display the view
			$view->display();
		}
		else {
			JError::raiseError( 404, JText::_("Key Not Found") );
		}
	}
}

?>