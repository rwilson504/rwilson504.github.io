import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import { isPublishedPost, sortPostsNewestFirst } from "../utils/posts";

export async function GET(context) {
  const posts = sortPostsNewestFirst(await getCollection("blog", isPublishedPost));
  return rss({
    title: "Richard A. Wilson",
    description:
      "Power Platform, AI, and side-project notes from Richard A. Wilson.",
    site: context.site,
    items: posts.map((post) => ({
      title: post.data.title,
      pubDate: post.data.pubDate,
      description: post.data.description,
      categories: [post.data.category, ...post.data.tags],
      link: `/blog/${post.id}/`,
    })),
  });
}
