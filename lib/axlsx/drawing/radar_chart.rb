# encoding: UTF-8
module Axlsx

  # The RadarChart is a radar chart that you can add to your worksheet.
  # @see Worksheet#add_chart
  # @see Chart#add_series
  # @see Package#serialize
  # @see README for an example
  class RadarChart < Chart

    # the category axis
    # @return [CatAxis]
    def cat_axis
      axes[:cat_axis]
    end
    alias :catAxis :cat_axis

    # the value axis
    # @return [ValAxis]
    def val_axis
      axes[:val_axis]
    end
    alias :valAxis :val_axis

    # The radar style of the chart
    # must be one of [:standard, :marker, :filled]
    # @return [Symbol]
    def radar_style
      @radar_style ||= :standard
    end
    alias :radarStyle :radar_style

    # Creates a new radar chart object
    # @param [GraphicFrame] frame The workbook that owns this chart.
    # @option options [Cell, String] title
    # @option options [Symbol] radar_style
    # @see Chart
    def initialize(frame, options={})
      @vary_colors = true
      super(frame, options)
      @series_type = RadarSeries
      @d_lbls = nil
    end

    # Serializes the object
    # @param [String] str
    # @return [String]
    def to_xml_string(str = '')
      super(str) do
        str << '<c:radarChart>'
        str << ('<c:radarStyle val="' << radar_style.to_s << '"/>')
        str << ('<c:varyColors val="' << vary_colors.to_s << '"/>')

        @series.each { |ser| ser.to_xml_string(str) }
        @d_lbls.to_xml_string(str) if @d_lbls
        axes.to_xml_string(str, :ids => true)
        str << '</c:radarChart>'
        axes.to_xml_string(str)
      end
    end

    # A hash of axes used by this chart. Radar charts have a value and
    # category axes specified via axes[:val_axes] and axes[:cat_axis]
    # @return [Axes]
    def axes
     @axes ||= Axes.new(:cat_axis => CatAxis, :val_axis => ValAxis)
    end
  end
end
