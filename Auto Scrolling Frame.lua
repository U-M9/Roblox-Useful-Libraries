type AutoScrollingFrame = {
    frame: ScrollingFrame,
    scrollingEnabled: boolean,
    lastScrollPosition: number,
    new: (frame: ScrollingFrame) -> AutoScrollingFrame,
    scrollToBottom: (self: AutoScrollingFrame) -> (),
    setScrollingEnabled: (self: AutoScrollingFrame, enabled: boolean) -> (),
    update: (self: AutoScrollingFrame) -> ()
}

local AutoScrollingFrame = {}
AutoScrollingFrame.__index = AutoScrollingFrame

function AutoScrollingFrame.new(frame: ScrollingFrame): AutoScrollingFrame
    local self = setmetatable({}, AutoScrollingFrame)
    self.frame = frame
    self.scrollingEnabled = true
    self.lastScrollPosition = 0

    self.frame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if self.scrollingEnabled then
            self:scrollToBottom()
        end
    end)

    self.frame.CanvasPosition = Vector2.new(0, 0)
    return self
end

function AutoScrollingFrame:scrollToBottom()
    self.frame.CanvasPosition = Vector2.new(0, self.frame.UIListLayout.AbsoluteContentSize.Y)
end

function AutoScrollingFrame:setScrollingEnabled(enabled: boolean)
    self.scrollingEnabled = enabled
end

function AutoScrollingFrame:update()
    if self.frame.CanvasPosition.Y < self.lastScrollPosition then
        self:setScrollingEnabled(false)
    elseif self.frame.CanvasPosition.Y > self.lastScrollPosition then
        self:setScrollingEnabled(true)
    end
    self.lastScrollPosition = self.frame.CanvasPosition.Y
end

return AutoScrollingFrame
