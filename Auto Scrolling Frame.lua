local auto_scroll_frame = {}
auto_scroll_frame.__index = auto_scroll_frame

function auto_scroll_frame.new(frame)
	local self = setmetatable({}, auto_scroll_frame)
	self.frame = frame
	self.scrolling_enabled = true
	self.last_scroll_position = 0
	self.frame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if self.scrolling_enabled then
			self:scroll_to_bottom()
		end
	end)
	self.frame.CanvasPosition = Vector2.new(0, 0)
	return self
end

function auto_scroll_frame:scroll_to_bottom()
	self.frame.CanvasPosition = Vector2.new(0, self.frame.UIListLayout.AbsoluteContentSize.Y)
end

function auto_scroll_frame:set_scrolling_enabled(enabled)
	self.scrolling_enabled = enabled
end

function auto_scroll_frame:update()
	if self.frame.CanvasPosition.Y < self.last_scroll_position then
		self:set_scrolling_enabled(false)
	elseif self.frame.CanvasPosition.Y > self.last_scroll_position then
		self:set_scrolling_enabled(true)
	end
	self.last_scroll_position = self.frame.CanvasPosition.Y
end

return auto_scroll_frame
